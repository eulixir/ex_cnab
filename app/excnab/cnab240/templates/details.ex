defmodule ExCnab.Cnab240.Templates.Details do
  @moduledoc """
  Module responsible to send the file to the correct template
  """
  import Helpers.ConvertPosition

  alias ExCnab.Cnab240.Validator.Details.Chunk, as: ChunkValidator

  @spec generate(List.t()) :: {:ok, List.t(Map.t())}
  def generate(raw_details) do
    raw_details
    |> build_recursive([])
    |> case do
      {:error, error} -> {:error, error}
      details -> ChunkValidator.call(details, raw_details)
    end
  end

  @spec encode(List.t()) :: List.t(Map.t())
  def encode(details) do
    details
    |> Enum.map(&payment_template(&1.servico.segmento, :encode, &1))
    |> Enum.join("\r\n")
  end

  defp build_recursive([], acc), do: acc

  defp build_recursive([register_detail | tail], acc) do
    with type <- convert_position(register_detail, 14),
         {:ok, detail_object} <- payment_template(type, :generate, register_detail) do
      build_recursive(tail, acc ++ [detail_object])
    end
  end

  defp payment_template(type, function, regsiter_detail) do
    apply(:"Elixir.ExCnab.Cnab240.Templates.Details.Model#{type}", function, [regsiter_detail])
  end
end
