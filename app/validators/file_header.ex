defmodule ExCnab.Cnab240.Validator.FileHeader do
  @moduledoc """
  An implementation of chain of responsibility to validate the file header.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def call(builded_header, raw_header) do
    with :ok <- validate_length(raw_header),
         :ok <- validate_layout_type(builded_header) do
      {:ok, builded_header}
    end
  end

  @spec_length 240
  defp validate_length(raw_header) do
    case String.length(raw_header) do
      @spec_length -> :ok
      number -> {:error, "Invalid file header length: #{number}, expected #{@spec_length}}"}
    end
  end

  @layout_version "082"
  defp validate_layout_type(%{arquivo: %{numero_versao_leiaute: version}}) do
    case version === @layout_version do
      true -> :ok
      _ -> {:error, "Invalid layout version: #{version}, expected #{@layout_version}"}
    end
  end
end
