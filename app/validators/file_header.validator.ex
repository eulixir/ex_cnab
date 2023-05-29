defmodule ExCnab.Cnab240.Validator.FileHeader do
  @moduledoc """
  An implementation of chain of responsibility to validate the file header.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t(), String.t()}
  def call(builded_header, raw_header) do
    with :ok <- validate_length(raw_header),
         :ok <- validate_layout_type(builded_header),
         :ok <- validate_record_type(builded_header.controle.registro) do
      {:ok, builded_header}
    else
      {:error, reason} ->
        {:error, reason, raw_header}
    end
  end

  @spec_length 240
  defp validate_length(raw_header) do
    case String.length(raw_header) do
      @spec_length -> :ok
      number -> {:error, "Tamanho do header inválido: #{number}, esperado #{@spec_length}}"}
    end
  end

  @layout_version "082"
  defp validate_layout_type(%{arquivo: %{numero_versao_leiaute: version}}) do
    case version === @layout_version do
      true -> :ok
      _ -> {:error, "Versão do layout inválida: #{version}, esperada #{@layout_version}"}
    end
  end

  @record_type "0"
  defp validate_record_type(record_type) do
    case record_type == @record_type do
      true -> :ok
      false -> {:error, "Tipo de registro inválido: #{record_type}, esperado: #{@record_type}"}
    end
  end
end
