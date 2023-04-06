defmodule ExCnab.Cnab240.Services.Encode do
  @moduledoc """
  Service to encode a txt CNAB 240.
  """

  alias ExCnab.Cnab240.Services.EncodeDetails
  alias ExCnab.Cnab240.Templates.Footer
  alias ExCnab.Cnab240.Templates.FileHeader

  @spec run(params :: String.t(), attrs :: Map.t()) :: {:ok, String.t()}
  def run(%{arquivo_header: header, details: details, trailer: footer}, _attrs) do
    encoded_header = FileHeader.encode(header)
    encoded_details = EncodeDetails.run(details)
    encoded_footer = Footer.encode(footer)

    raw = [encoded_header, encoded_details, encoded_footer] |> Enum.join("\r\n")

    File.rm("./priv/docs/banana.rem")
    File.write("./priv/docs/banana.rem", raw)

    {:ok, raw}
  end

  @spec run!(params :: Map.t(), attrs :: Map.t()) :: String.t()
  def run!(%{arquivo_header: header, details: details, trailer: footer}, _attrs) do
    encoded_header = FileHeader.encode(header)
    encoded_details = EncodeDetails.run(details)
    encoded_footer = Footer.encode(footer)

    raw = [encoded_header, encoded_details, encoded_footer] |> Enum.join("\r\n")

    File.rm("./priv/docs/banana.rem")
    File.write("./priv/docs/banana.rem", raw)

    raw
  end
end
