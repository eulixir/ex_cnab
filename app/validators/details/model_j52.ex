defmodule ExCnab.Cnab240.Validator.Details.ModelJ52 do
  @moduledoc """
  An implementation of chain of responsibility to validate the model J.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def call(builded_details, raw_details) do
    with :ok <- validate_length(raw_details),
         :ok <- validate_record_type(builded_details.controle.registro),
         :ok <- validate_model_type(builded_details.servico.segmento) do
      {:ok, builded_details}
    end
  end

  @cnab_size 240
  defp validate_length(raw_details) do
    case String.length(raw_details) do
      @cnab_size ->
        :ok

      number ->
        {:error, "Invalid file details length: #{number}, and should be #{@cnab_size}"}
    end
  end

  @record_type "3"
  defp validate_record_type(record_type) do
    case record_type == @record_type do
      true ->
        :ok

      false ->
        {:error, "Invalid record type: #{record_type}, and should be #{@record_type}}"}
    end
  end

  @model_type "J"
  defp validate_model_type(model_type) do
    case model_type == @model_type do
      true ->
        :ok

      false ->
        {:error, "Invalid record type: #{model_type}, and should be #{@model_type}}"}
    end
  end
end
