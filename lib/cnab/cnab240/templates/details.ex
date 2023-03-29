defmodule Cnab.Cnab240.Templates.Details do
  @moduledoc """

  """
  alias Cnab.Cnab240.Templates.Details.{ModelA, ModelB}
  import Helpers.ConvertPosition

  @spec generate(List.t()) :: {:ok, List.t(Map.t())}
  def generate(details) do
    formated_details =
      Enum.map(details, fn register_detail ->
        {:ok, detail_object} =
          register_detail
          |> get_payment_segment()
          |> generate_payment_template(register_detail)

        detail_object
      end)

    sum_values(formated_details)

    {:ok, formated_details}
  end

  defp get_payment_segment(regsiter_detail), do: convert_position(regsiter_detail, 14, 14)

  defp generate_payment_template("A", regsiter_detail), do: ModelA.generate(regsiter_detail)

  defp generate_payment_template("B", regsiter_detail), do: ModelB.generate(regsiter_detail)

  defp sum_values(formated_details) do
    Enum.reduce(formated_details, 0, fn detail, acc ->
      case Map.has_key?(detail, :credito) do
        true -> String.to_integer(detail.credito.valor_pagamento) + acc
        false -> acc
      end
    end)
  end
end
