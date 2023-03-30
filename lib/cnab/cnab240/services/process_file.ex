defmodule Cnab.Cnab240.Services.ProcessFile do
  @moduledoc """
  Service to read and generate info about the CNAB 240 file.
  """

  alias Cnab.Cnab240.Services.Details
  alias Cnab.Cnab240.Templates.Footer
  alias Cnab.Cnab240.Templates.FileHeader

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
    map =
      file.path
      |> File.read!()
      |> String.split("\r\n")
      |> classify_by_type()

    {:ok, filename_info} = GetFileInfo.run(file.filename)

    {:ok, file_header} = FileHeader.generate(map.file_header)
    {:ok, details} = Details.run(map.chunks)
    {:ok, footer} = Footer.generate(map.file_footer)

    {:ok,
     %{
       cnab240: %{
         arquivo_header: file_header,
         detalhes: details,
         trailer: footer
       },
       informacoes_extras: filename_info
     }}
  end

  defp classify_by_type(array) do
    file_header = Enum.at(array, 0)

    file_footer = Enum.at(array, -2)

    shorted_array =
      array
      |> Enum.drop(1)
      |> Enum.drop(-2)

    chunks =
      shorted_array
      |> get_footers_index()
      |> build_details_object(shorted_array)

    %{file_header: file_header, file_footer: file_footer, chunks: chunks}
  end

  defp verify_type(raw_string) do
    type = String.slice(raw_string, 7..7)

    @item_type[type]
  end

  defp get_footers_index(shorted_array) do
    Enum.reduce(shorted_array, [], fn item, acc ->
      case verify_type(item) do
        :chunk_footer ->
          index = Enum.find_index(shorted_array, &(&1 == item))

          acc ++ [index]

        _ ->
          acc
      end
    end)
  end

  defp build_details_object(list_footer_index, shorted_array) do
    {_, details} =
      Enum.reduce(list_footer_index, {shorted_array, %{chunks: []}}, fn index,
                                                                        {list_acc, map_acc} ->
        footer = Enum.at(shorted_array, index)

        {[header | details], shorted_array} = Enum.split(list_acc, index + 1)

        details = Enum.drop(details, -1) |> Enum.drop(1)
        key_id = Enum.find_index(list_footer_index, &(&1 == index)) + 1

        new_map = %{
          "chunk_register_#{key_id}": %{
            header: header,
            detail: details,
            footer: footer
          }
        }

        {shorted_array, Map.update(map_acc, :chunks, [new_map], &(&1 ++ [new_map]))}
      end)

    details
  end
end
