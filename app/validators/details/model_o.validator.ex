defmodule ExCnab.Cnab240.Validator.Details.ModelO do
  @moduledoc """
  An implementation of chain of responsibility to validate the model O.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t(), String.t()}
  def call(builded_detail, raw_detail) do
    with :ok <- validate_length(raw_detail),
         :ok <- validate_record_type(builded_detail.controle.registro),
         :ok <- validate_model_type(builded_detail.servico.segmento) do
      {:ok, builded_detail}
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
        {:error, "Tamanho do segmento inválido: #{number}, deveria ser: #{@cnab_size}"}
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

  @model_type "O"
  defp validate_model_type(model_type) do
    case model_type == @model_type do
      true ->
        :ok

      false ->
        {:error, "Tipo de segmento incorreto: #{model_type}, esperado: #{@model_type}}"}
    end
  end
end
