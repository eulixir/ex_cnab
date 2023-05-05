defmodule ExCnab.Cnab240.Validator.FileFooter do
  @moduledoc """
  An implementation of chain of responsibility to validate the file footer.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def call(builded_footer, raw_footer) do
    with :ok <- validate_length(raw_footer),
         :ok <- validate_chunk_size(builded_footer.total.qnt_lotes),
         :ok <- validate_records_size(builded_footer.total.qnt_registros) do
      {:ok, builded_footer}
    end
  end

  @cnab_size 240
  defp validate_length(raw_footer) do
    case String.length(raw_footer) do
      @cnab_size ->
        :ok

      number ->
        {:error, "Invalid file footer length: #{number}, and should be #{@cnab_size}"}
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
         "The amount of batches in this file is higher than the limit proposed by FEBRABAN #{@batch_limit},
         the amount of batches for this cnab is #{qnt_lotes}"}
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
         "The amount of records in this file is higher than the limit proposed by FEBRABAN #{@batch_limit}, the amount of records for this cnab is #{qnt_registros}"}
    end
  end
end
