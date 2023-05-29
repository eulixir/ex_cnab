defmodule ExCnab.Cnab240.Validator.Details.ChunkFooter do
  @moduledoc """
  An implementation of chain of responsibility to validate the chunk footer.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def call(builded_footer, raw_footer) do
    with :ok <- validate_length(raw_footer),
         :ok <- validate_record_type(builded_footer.controle.registro) do
      {:ok, builded_footer}
    else
      {:error, reason} ->
        {:error, reason, raw_footer}
    end
  end

  @cnab_size 240
  defp validate_length(raw_footer) do
    case String.length(raw_footer) do
      @cnab_size ->
        :ok

      number ->
        {:error, "Tamanho inválido para o footer: #{number}, deveria ser #{@cnab_size}"}
    end
  end

  @record_type "5"
  defp validate_record_type(record_type) do
    case record_type == @record_type do
      true ->
        :ok

      false ->
        {:error, "Tipo de registro incorreto: #{record_type}, deveria ser #{@record_type}}"}
    end
  end
end
