defmodule ExCnab.Cnab240.Services.HasIdenticalInformations do
  @moduledoc """
  Service to check if the CNAB 240 file has identical informations.
  """

  @spec run(list) :: :ok | {:error, String.t()}
  def run(list), do: find_list(list, list, :ok)

  defp find_list(list, [hd | tl], :ok) do
    index = Enum.find_index(tl, &(&1 == hd))

    currentIndex = Enum.find_index(list, &(&1 == hd))

    case index do
      nil ->
        find_list(list, tl, :ok)

      _ ->
        {:error, "A linha #{currentIndex + 1} está duplicada"}
    end
  end

  defp find_list(_list, [], :ok), do: :ok
end
