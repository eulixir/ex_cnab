defmodule ExCnab.Cnab240.Services.Encode do
  @moduledoc """
  Service to encode a txt CNAB 240.
  """

  alias ExCnab.Cnab240.Templates.FileHeader
  # @spec run(params :: String.t(), attrs :: Map.t()) :: {:ok, String.t()}
  def run(params, _attrs) do
    {:ok, FileHeader.encode(params)}
  end

  # @spec run!(params :: String.t(), attrs :: Map.t()) :: String.t()
  def run!(params, _attrs) do
    file = FileHeader.encode(params)

    File.write("banana.rem", file)
  end
end
