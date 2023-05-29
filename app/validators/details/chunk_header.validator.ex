defmodule ExCnab.Cnab240.Validator.Details.ChunkHeader do
  @moduledoc """
  An implementation of chain of responsibility to validate the chunk header.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t(), String.t()}
  def call(builded_header, raw_header) do
    with :ok <- validate_length(raw_header),
         :ok <- chunk_layout_version(builded_header.servico.layout_lote),
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
      @spec_length ->
        :ok

      number ->
        {:error, "Tamanho do header do lote inválido: #{number}, esperado: #{@spec_length}}"}
    end
  end

  @layout_chunk_version "042"
  defp chunk_layout_version(layout) do
    case layout === @layout_chunk_version do
      true -> :ok
      _ -> {:error, "Versão do layout inválida: #{layout}, esperado: #{@layout_chunk_version}"}
    end
  end

  @record_type "1"
  defp validate_record_type(record_type) do
    case record_type == @record_type do
      true -> :ok
      false -> {:error, "Tipo de registro inválido: #{record_type}, esperado: #{@record_type}"}
    end
  end
end
