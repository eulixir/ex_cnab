defmodule ExCnab.Cnab240.Services.GetFileInfo do
  @moduledoc """
  Service to get file infos from filename
  """

  import Helpers.ConvertPosition

  alias ExCnab.Cnab240.Validator.Filename, as: FilenameValidator

  @spec run(String.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def run(file, attrs \\ %{}) do
    filename = Path.basename(file)
    params = Map.get(attrs, :filename, filename)

    params
    |> String.slice(0..3)
    |> String.match?(~r/\d+/)
    |> filename_template(params)
    |> FilenameValidator.call()
  end

  defp filename_template(true, filename) do
    %{
      codigo_convenio: convert_position(filename, 1, 3),
      dia_geracao_arquivo: convert_position(filename, 4, 5),
      codigo_mes_geracao_arquivo: convert_position(filename, 6),
      sequencia_arquivo: convert_position(filename, 7, 8),
      formato_arquivo: convert_position(filename, 9, 12),
      nome_arquivo: filename
    }
  end

  defp filename_template(false, filename) do
    %{
      codigo_convenio: convert_position(filename, 1, 4),
      dia_geracao_arquivo: convert_position(filename, 5, 6),
      sequencia_arquivo: convert_position(filename, 7, 8),
      formato_arquivo: convert_position(filename, 9, 12),
      nome_arquivo: filename
    }
  end
end
