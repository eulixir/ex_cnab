defmodule ExCnab.Cnab240.Validator.Details.ModelA do
  @moduledoc """
  An implementation of chain of responsibility to validate the model A.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def call(builded_detail, raw_detail) do
    with :ok <- validate_length(raw_detail),
         :ok <- validate_record_type(builded_detail.controle.registro),
         :ok <- validate_model_type(builded_detail.servico.segmento),
         :ok <- validate_currency_type(builded_detail.credito.moeda.tipo) do
      {:ok, builded_detail}
    end
  end

  @cnab_size 240
  defp validate_length(raw_detail) do
    case String.length(raw_detail) do
      @cnab_size ->
        :ok

      number ->
        {:error, "Invalid file detail length: #{number}, and should be #{@cnab_size}"}
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

  @model_type "A"
  defp validate_model_type(model_type) do
    case model_type == @model_type do
      true ->
        :ok

      false ->
        {:error, "Invalid record type: #{model_type}, and should be #{@model_type}}"}
    end
  end

  @currency_type "BRL"
  defp validate_currency_type(currency_type) do
    case currency_type == @currency_type do
      true ->
        :ok

      false ->
        {:error, "Invalid currency type: #{currency_type}, and should be #{@currency_type}}"}
    end
  end
end