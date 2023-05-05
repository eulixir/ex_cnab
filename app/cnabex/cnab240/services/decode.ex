defmodule ExCnab.Cnab240.Services.Decode do
  @moduledoc """
  Service to read and generate info about the CNAB 240 file.
  """

  alias ExCnab.Cnab240.Services.BuildDetails
  alias ExCnab.Cnab240.Templates.FileHeader
  alias ExCnab.Cnab240.Templates.Footer

  alias ExCnab.Cnab240.Services.GetFileInfo

  @item_type %{
    "0" => :file_header,
    "1" => :chunk_header,
    "2" => :chunk_first_register,
    "3" => :details,
    "5" => :chunk_footer,
    "9" => :file_footer
  }

  @spec run(String.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def run(file, attrs \\ %{}) do
    with {:ok, map} <- read_file(file),
         {:ok, file_header} <- FileHeader.generate(map.file_header, attrs),
         {:ok, details} <- BuildDetails.run(map.chunks, attrs),
         {:ok, footer} <- Footer.generate(map.file_footer, attrs),
         {:ok, filename_info} <- GetFileInfo.run(file, file_header, attrs) do
      build_response(file_header, details, footer, filename_info, :ok)
    end
  end

  @spec run!(String.t(), Map.t()) :: Map.t() | {:error, String.t()}
  def run!(file, attrs) do
    with {:ok, map} <- read_file(file),
         {:ok, file_header} <- FileHeader.generate(map.file_header, attrs),
         {:ok, details} <- BuildDetails.run(map.chunks, attrs),
         {:ok, footer} <- Footer.generate(map.file_footer, attrs),
         {:ok, filename_info} <- GetFileInfo.run(file, file_header, attrs) do
      build_response(file_header, details, footer, filename_info, :no)
    end
  end

  defp read_file(file) do
    with {:ok, content} <- File.read(file),
         {:ok, %{size: size}} <- File.stat(file),
         true <- size <= 524_288_000 do
      content
      |> String.split("\r\n")
      |> classify_by_type()
    else
      false ->
        {:error, "File size is bigger than 500MB"}

      {:error, reason} ->
        {:error, "Can't read file: #{inspect(reason)}"}
    end
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

    {:ok, %{file_header: file_header, file_footer: file_footer, chunks: chunks}}
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

        footer_index =
          list_acc
          |> get_footers_index()
          |> hd()

        {[header | details], shorted_array} = Enum.split(list_acc, footer_index + 1)

        details = Enum.drop(details, -1)

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

  defp build_response(file_header, details, footer, filename_info, ok?) do
    response = %{
      cnab240: %{
        header_arquivo: file_header,
        detalhes: details,
        trailer: footer
      },
      informacoes_extras: filename_info
    }

    case ok? do
      :ok ->
        {:ok, response}

      _ ->
        response
    end
  end
end
