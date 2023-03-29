defmodule Cnab.Cnab240.Services.Details do
  alias Cnab.Cnab240.Templates.ChunkHeader
  alias Cnab.Cnab240.Templates.Details
  alias Cnab.Cnab240.Templates.ChunkFooter

  def run(%{chunks: chunks}) do
    {:ok,
     Enum.map(chunks, fn detail ->
       index = Enum.find_index(chunks, &(&1 == detail)) + 1
       detail_key_id = :"chunk_register_#{index}"

       %{header: header, detail: details, footer: footer} = detail[detail_key_id]

       {:ok, chunk_header} = ChunkHeader.generate(header)
       {:ok, details} = Details.generate(details)
       {:ok, footer} = ChunkFooter.generate(footer)

       %{header_lote: chunk_header, lotes: details, trailer_lote: footer}
     end)}
  end
end
