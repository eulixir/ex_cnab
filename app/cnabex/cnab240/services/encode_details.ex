defmodule ExCnab.Cnab240.Services.EncodeDetails do
  @moduledoc """
  Service to encode params to details
  """
  alias ExCnab.Cnab240.Templates.ChunkFooter
  alias ExCnab.Cnab240.Templates.Details
  alias ExCnab.Cnab240.Templates.ChunkHeader

  @spec run(List.t()) :: List.t(Map.t())
  def run(details) do
    Enum.map(details, fn detail ->
      %{header_lote: header, lotes: details, trailer_lote: footer} = detail

      %{servico: %{segmento: segmento}} = hd(details)

      encoded_header = ChunkHeader.encode(header)
      encoded_detail = Details.encode(details)
      encoded_footer = ChunkFooter.encode(segmento, footer)

      [encoded_header, encoded_detail, encoded_footer] |> Enum.join("\r\n")
    end)
    |> Enum.join("\r\n")
  end
end
