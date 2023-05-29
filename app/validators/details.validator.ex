defmodule ExCnab.Cnab240.Validator.Details do
  @moduledoc """
  An implementation of chain of responsibility to validate the detailsr.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t(), String.t()}
  def call(builded_batches, batches) do
    with :ok <- validate_length(batches) do
      {:ok, builded_batches}
    else
      {:error, reason} ->
        {:error, reason, batches}
    end
  end

  @spec_length 70
  defp validate_length(batches) do
    batches = length(batches)

    case batches <= @spec_length do
      true -> :ok
      false -> {:error, "Tamanho dos detalhes inválido: #{batches}, esperado: #{@spec_length}}"}
    end
  end
end
