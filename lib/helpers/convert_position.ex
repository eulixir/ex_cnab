defmodule Helpers.ConvertPosition do
  @moduledoc """
  Helper to convert machine position to human position
  """

  @spec convert_position(String.t(), Integer.t(), Integer.t()) :: String.t()
  def convert_position(string, from, to) do
    from = from - 1
    to = to - 1

    String.slice(string, from..to)
  end

  @spec convert_position(String.t(), Integer.t()) :: String.t()
  def convert_position(string, unique_position) do
    unique_position = unique_position - 1

    String.slice(string, unique_position..unique_position)
  end
end
