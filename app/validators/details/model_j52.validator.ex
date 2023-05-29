defmodule ExCnab.Cnab240.Validator.Details.ModelJ52 do
  @moduledoc """
  An implementation of chain of responsibility to validate the model J.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t(), String.t()}
  def call(builded_details, raw_detail) do
    with :ok <- validate_length(raw_detail),
         :ok <- validate_record_type(builded_details.controle.registro),
         :ok <- validate_model_type(builded_details.servico.segmento) do
      {:ok, builded_details}
    else
      {:error, reason} ->
        {:error, reason, raw_detail}
    end
  end

  @cnab_size 240
  defp validate_length(raw_detail) do
    case String.length(raw_detail) do
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
        {:error, "Tipo de registro incorreto: #{record_type}, deveria ser #{@record_type}}"}
    end
  end

  @model_type "J"
  defp validate_model_type(model_type) do
    case model_type == @model_type do
      true ->
        :ok

      false ->
        {:error, "Tipo de segmento incorreto: #{model_type}, esperado: #{@model_type}}"}
    end
  end
end
