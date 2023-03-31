defmodule Cnab.Cnab240.Templates.Details do
  @moduledoc """

  """
  alias Cnab.Cnab240.Templates.Details.{ModelA, ModelB, ModelO}
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

    {:ok, formated_details}
  end

  defp get_payment_segment(regsiter_detail), do: convert_position(regsiter_detail, 14, 14)

  defp generate_payment_template("A", regsiter_detail), do: ModelA.generate(regsiter_detail)

  defp generate_payment_template("B", regsiter_detail), do: ModelB.generate(regsiter_detail)

  defp generate_payment_template("O", regsiter_detail), do: ModelO.generate(regsiter_detail)
end
