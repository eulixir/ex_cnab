defmodule ExCnab.Cnab240.Services.CalcAmount do
  @spec run(Map.t()) :: Integer.t()
  def run(details) do
    details
    |> hd()
    |> Map.get(:servico)
    |> Map.get(:segmento)
    |> calc_model(details)
  end

  defp calc_model("A", details) do
    Enum.reduce(details, 0, fn detail, acc ->
      case detail.servico.segmento == "A" do
        true ->
          acc + String.to_integer(detail.credito.valor_pagamento)

        false ->
          acc
      end
    end)
  end

  defp calc_model("J", details) do
    Enum.reduce(details, 0, fn detail, acc ->
      case detail.servico.segmento == "J" and !Map.has_key?(detail, :cod_reg) do
        true ->
          acc + String.to_integer(detail.pagamento.valor_pagamento)

        false ->
          acc
      end
    end)
  end

  defp calc_model("N", details) do
    Enum.reduce(details, 0, fn detail, acc ->
      case detail.servico.segmento == "J" do
        true ->
          acc + String.to_integer(detail.pagamento.valor_pagamento)

        false ->
          acc
      end
    end)
  end

  defp calc_model("O", details) do
    Enum.reduce(details, 0, fn detail, acc ->
      case detail.servico.segmento == "O" do
        true ->
          acc + String.to_integer(detail.pagamento.valor_pagamento)

        false ->
          acc
      end
    end)
  end
end
