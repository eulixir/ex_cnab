defmodule ExCnab.Cnab240.Validator.Filename do
  @moduledoc """
  An implementation of chain of responsibility to validate the filename.
  """

  @spec call(Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def call(attrs) do
    {:ok, attrs}
  end

  # @possible_extensions ~w(.ret .rem .RET .REM .txt)
  # defp validate_extension(attrs) do
  #   case attrs.formato_arquivo in @possible_extensions do
  #     true -> :ok
  #     false -> {:error, "Invalid extension"}
  #   end
  # end

  # @possible_days Enum.to_list(1..31)
  # @possible_months ~w(1 2 3 4 5 6 7 8 9 O N D)
  # defp validate_date(%{codigo_mes_geracao_arquivo: month, formato_arquivo: file_format} = attrs)
  #      when file_format in [".rem", ".REM"] do
  #   day = attrs.dia_geracao_arquivo |> String.to_integer()

  #   case month in @possible_months and day in @possible_days do
  #     true -> :ok
  #     false -> {:error, "Invalid day and month"}
  #   end
  # end

  # defp validate_date(%{formato_arquivo: file_format} = attrs)
  #      when file_format in [".rem", ".REM"] do
  #   case attrs.dia_geracao_arquivo in @possible_days do
  #     true -> :ok
  #     false -> {:error, "Invalid day"}
  #   end
  # end

  # defp validate_date(%{formato_arquivo: file_format} = attrs)
  #      when file_format in [".rem", ".REM"] do
  #   case attrs.dia_geracao_arquivo in @possible_days do
  #     true -> :ok
  #     false -> {:error, "Invalid day"}
  #   end
  # end

  # defp validate_date(_attrs), do: :ok
end
