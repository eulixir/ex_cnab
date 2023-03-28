defmodule Cnab.Cnab240.Services.ProcessFile do
  @moduledoc """
  Service to read and generate info about the CNAB 240 file.
  """

  alias Cnab.Cnab240.Templates.Footer
  alias Cnab.Cnab240.Templates.FileHeader
  alias Cnab.Cnab240.Templates.ChunkHeader
  alias Cnab.Cnab240.Templates.Details
  alias Cnab.Cnab240.Services.GetFileInfo

  @item_type %{
    "0" => :file_header,
    "1" => :chunk_header,
    "2" => :chunk_first_register,
    "3" => :details,
    "5" => :chunk_footer,
    "9" => :file_footer
  }

  @spec run(Plug.Upload.t()) :: {:ok, Map.t()} | {:error, Any.t()}
  def run(file) do
    case String.contains?(file.filename, "REM") do
      true ->
        process_file(file)

      false ->
        {:error, %{status: 422, message: "Verify your filename, maybe something wen't wrong"}}
    end
  end

  defp process_file(file) do
    map =
      file.path
      |> File.read!()
      |> String.split("\r\n")
      |> classify_by_type()

    {:ok, filename_info} = GetFileInfo.run(file.filename)

    {:ok, file_header} = FileHeader.generate(map.file_header)
    {:ok, chunk_header} = ChunkHeader.generate(map.chunk_header)
    {:ok, detail} = Details.generate(map.details)
    {:ok, footer} = Footer.generate(map.file_footer)

    {:ok,
     %{
       arquivo: %{
         arquivo_header: file_header,
         lote_header: chunk_header,
         trailer: footer,
         detalhes: detail
       },
       informacoes_extras: filename_info
     }}
  end

  defp classify_by_type(array) do
    array
    |> Enum.drop(-1)
    |> Enum.reduce(%{}, fn raw_string, acc ->
      type = verify_type(raw_string)

      Map.update(acc, type, [raw_string], &(&1 ++ [raw_string]))
    end)
  end

  defp verify_type(raw_string) do
    type = String.slice(raw_string, 7..7)

    @item_type[type]
  end
end
