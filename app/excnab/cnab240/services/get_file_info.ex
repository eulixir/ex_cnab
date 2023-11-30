defmodule ExCnab.Cnab240.Services.GetFileInfo do
  @moduledoc """
  Service to get file infos from filename
  """

  import Helpers.ConvertPosition

  alias ExCnab.Cnab240.Validator.Filename, as: FilenameValidator

  @spec run(String.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def run(file, _attrs \\ %{}) do
    filename = Path.basename(file)

    filename
    |> filename_template()
    |> FilenameValidator.call()
  end

  defp filename_template(filename) do
    %{
      codigo_convenio: convert_position(filename, 1, 5),
      dia_geracao_arquivo: convert_position(filename, 6, 7),
      mes_geracao_arquivo: convert_position(filename, 8, 9),
      ano_geracao_arquivo: convert_position(filename, 10, 13),
      sequencia_arquivo: convert_position(filename, 14, 15),
      formato_arquivo: convert_position(filename, 16, 19),
      nome_arquivo: filename
    }
  end
end
