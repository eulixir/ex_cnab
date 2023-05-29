defmodule ExCnab.Cnab240.Validator.FileFooter do
  @moduledoc """
  An implementation of chain of responsibility to validate the file footer.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t(), String.t()}
  def call(builded_footer, raw_footer) do
    with :ok <- validate_length(raw_footer),
         :ok <- validate_chunk_size(builded_footer.total.qnt_lotes),
         :ok <- validate_records_size(builded_footer.total.qnt_registros),
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
        {:error, "Tamanho do rodapé invalido: #{number}, o esperado era: #{@cnab_size}"}
    end
  end

  @batch_limit 70
  defp validate_chunk_size(qnt_lotes) do
    qnt_lotes = String.to_integer(qnt_lotes)

    case qnt_lotes <= @batch_limit do
      true ->
        :ok

      false ->
        {:error,
         "A quantidade de lotes nesse arquivo é maior do que o limite proposto pela FEBRABAN#{@batch_limit},
         a quantidade esperada para esse cnab é de: #{qnt_lotes}"}
    end
  end

  @batch_limit 10_000
  defp validate_records_size(qnt_registros) do
    qnt_registros = String.to_integer(qnt_registros)

    case qnt_registros <= @batch_limit do
      true ->
        :ok

      false ->
        {:error,
         "A quantidade de registros nesse arquivo é maior do que o limite proposto pela FEBRABAN #{@batch_limit},
         a quantidade de registros para esse cnab é: #{qnt_registros}"}
    end
  end

  @record_type "9"
  defp validate_record_type(record_type) do
    case record_type == @record_type do
      true ->
        :ok

      false ->
        {:error, "Tipo de registro inválido: #{record_type}, deveria ser: #{@record_type}"}
    end
  end
end
