defmodule ExCnab.Cnab240.Validator.Details.Chunk do
  @moduledoc """
  An implementation of chain of responsibility to validate the chunks
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t(), String.t()}
  def call(details, raw_detail) do
    with :ok <- validate_length(raw_detail),
         :ok <- validate_details_length(details, raw_detail) do
      {:ok, details}
    end
  end

  @spec_length 10_000
  defp validate_length(raw_detail) do
    length = length(raw_detail)

    case length < @spec_length do
      true ->
        :ok

      false ->
        {:error,
         "Tamanho total do lote inválido: #{length}, não pode ser maior que #{@spec_length}}"}
    end
  end

  defp validate_details_length(details, raw_detail) do
    raw_length = length(raw_detail)
    length = length(details)

    case length == raw_length do
      true ->
        :ok

      false ->
        {:error, "Tamanho dos detalhes inválido: #{length}, esperado: #{raw_length},
         if you have this error, please contact the maintainers and open an issue"}
    end
  end
end
