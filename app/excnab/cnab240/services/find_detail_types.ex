defmodule ExCnab.Cnab240.Services.FindDetailsTypes do
  @moduledoc """
  Find all details types from a CNAB 240 file
  """

  @spec run(Map.t()) :: {:ok, List.t()}
  def run(%{cnab240: %{detalhes: details}}), do: {:ok, get_type(details)}

  @spec run!(Map.t()) :: List.t()
  def run!(%{cnab240: %{detalhes: details}}), do: get_type(details)

  defp get_type(details) do
    details
    |> Enum.map(& &1.lotes)
    |> Enum.map(fn x -> Enum.map(x, & &1.servico.segmento) end)
    |> Enum.flat_map(& &1)
    |> Enum.uniq()
  end
end
