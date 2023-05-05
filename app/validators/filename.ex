defmodule ExCnab.Cnab240.Validator.Filename do
  @moduledoc """
  An implementation of chain of responsibility to validate the filename.
  """

  @spec call(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def call(attrs, codigo_convenio_banco) do
    with :ok <- validate_extension(attrs),
         :ok <- validate_bank_code(attrs, codigo_convenio_banco),
         :ok <- validate_date(attrs) do
      {:ok, attrs}
    end
  end

  @possible_extensions ~w(.ret .rem .RET .REM)
  defp validate_extension(attrs) do
    case attrs.formato_arquivo in @possible_extensions do
      true -> :ok
      false -> {:error, "Invalid extension"}
    end
  end

  defp validate_bank_code(attrs, codigo_convenio_banco) do
    case attrs.codigo_convenio == String.trim(codigo_convenio_banco) do
      true -> :ok
      false -> {:error, "Invalid bank code"}
    end
  end

  @possible_days Enum.to_list(1..31)
  @possible_months ~w(1 2 3 4 5 6 7 8 9 O N D)
  defp validate_date(%{codigo_mes_geracao_arquivo: month} = attrs)
       when attrs.formato_arquivo in [".rem", ".REM"] do
    day = attrs.dia_geracao_arquivo |> String.to_integer()

    case month in @possible_months and day in @possible_days do
      true -> :ok
      false -> {:error, "Invalid day and month"}
    end
  end

  defp validate_date(attrs) when attrs.formato_arquivo in [".rem", ".REM"] do
    case attrs.dia_geracao_arquivo in @possible_days do
      true -> :ok
      false -> {:error, "Invalid day"}
    end
  end
end
