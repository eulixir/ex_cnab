defmodule ExCnab.Cnab240.Validator.Details.Chunk do
  @moduledoc """
  An implementation of chain of responsibility to validate the chunks
  """

  @spec call(List.t(), List.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def call(details, raw_details) do
    with :ok <- validate_length(raw_details),
         :ok <- validate_details_length(details, raw_details) do
      {:ok, details}
    end
  end

  @spec_length 10_000
  defp validate_length(raw_details) do
    length = length(raw_details)

    case length < @spec_length do
      true ->
        :ok

      false ->
        {:error, "Invalid file header length: #{length}, the max size is #{@spec_length}}"}
    end
  end

  defp validate_details_length(details, raw_details) do
    raw_length = length(raw_details)
    length = length(details)

    case length == raw_length do
      true ->
        :ok

      false ->
        {:error, "Invalid details length: #{length}, expected #{raw_length},
         if you have this error, please contact the maintainers and open an issue"}
    end
  end
end
