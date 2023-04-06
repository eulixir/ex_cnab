defmodule ExCnab.Cnab240.Templates.Details do
  @moduledoc """
  Module responsible to send the file to the correct template
  """
  import Helpers.ConvertPosition

  @spec generate(List.t()) :: {:ok, List.t(Map.t())}
  def generate(details) do
    formated_details =
      Enum.map(details, fn register_detail ->
        {:ok, detail_object} =
          register_detail
          |> convert_position(14)
          |> payment_template(register_detail, :generate)

        detail_object
      end)

    {:ok, formated_details}
  end

  @spec encode(List.t()) :: List.t(Map.t())
  def encode(details) do
    Enum.map(details, fn detail ->
      detail.servico.segmento

      payment_template(detail.servico.segmento, detail, :encode)
    end)
    |> Enum.join("\r\n")
  end

  defp payment_template(type, regsiter_detail, function) do
    apply(:"Elixir.ExCnab.Cnab240.Templates.Details.Model#{type}", function, [regsiter_detail])
  end
end
