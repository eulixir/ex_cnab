defmodule ExCnab.Cnab240.Templates.Details do
  @moduledoc """
  Module responsible to send the file to the correct template
  """
  import Helpers.ConvertPosition

  alias ExCnab.Cnab240.Templates.Details.{
    ModelA,
    ModelB,
    ModelJ,
    ModelJ52,
    ModelO,
    ModelW,
    ModelZ
  }

  @spec generate(List.t()) :: {:ok, List.t(Map.t())}
  def generate(details) do
    formated_details =
      Enum.map(details, fn register_detail ->
        {:ok, detail_object} =
          register_detail
          |> convert_position(14)
          |> generate_payment_template(register_detail)

        detail_object
      end)

    {:ok, formated_details}
  end

  defp generate_payment_template("A", regsiter_detail), do: ModelA.generate(regsiter_detail)

  defp generate_payment_template("B", regsiter_detail), do: ModelB.generate(regsiter_detail)

  defp generate_payment_template("J", regsiter_detail), do: ModelJ.generate(regsiter_detail)

  defp generate_payment_template("J-52", regsiter_detail), do: ModelJ52.generate(regsiter_detail)

  defp generate_payment_template("O", regsiter_detail), do: ModelO.generate(regsiter_detail)

  defp generate_payment_template("W", regsiter_detail), do: ModelW.generate(regsiter_detail)

  defp generate_payment_template("Z", regsiter_detail), do: ModelZ.generate(regsiter_detail)
end
