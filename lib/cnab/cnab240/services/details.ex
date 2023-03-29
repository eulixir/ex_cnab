defmodule Cnab.Cnab240.Services.Details do
  alias Cnab.Cnab240.Templates.ChunkHeader
  alias Cnab.Cnab240.Templates.Details
  alias Cnab.Cnab240.Templates.ChunkFooter

  @payment_mapper %{
    "03": %{
      descricao: "Boleto Eletrônico",
      "30": %{
        descricao: "Liquidação de Títulos do Próprio Banco"
      },
      "31": %{
        descricao: "Pagamento de Títulos de Outros Bancos"
      }
    },
    "20": %{
      descricao: "Pagamento Fornecedor",
      "01": %{
        descricao: "Crédito em Conta-Corrente"
      },
      "03": %{
        descricao: "DOC"
      },
      "10": %{
        descricao: "Ordem de Pagamento - OP"
      },
      "41": %{
        descricao: "TED - Transferência entre Clientes"
      },
      "45": %{
        descricao: "PIX - Transferência"
      }
    },
    "22": %{
      descricao: "Pagamento de Contas, Tributos e Impostos",
      "11": %{
        descricao: "Pagamento de Contas e Tributos com Código de Barras"
      },
      "16": %{
        descricao: "Tributo DARF Normal"
      },
      "17": %{
        descricao: "Tributo GPS (Guia da Previdência Social)"
      },
      "18": %{
        descricao: "Tributo DARF Simples"
      },
      "03": %{
        descricao: "Pagamento Salários/Folha de Pagamento",
        "01": %{
          descricao: "Crédito em Conta-Corrente"
        }
      }
    }
  }

  def run(%{chunks: chunks}) do
    {:ok,
     Enum.map(chunks, fn detail ->
       index = Enum.find_index(chunks, &(&1 == detail)) + 1
       detail_key_id = :"chunk_register_#{index}"

       %{header: header, detail: details, footer: footer} = detail[detail_key_id]
       {:ok, header} = ChunkHeader.generate(header)
       {:ok, details} = Details.generate(details)
       {:ok, footer} = ChunkFooter.generate(footer)

       get_chunk_infos(header)

       %{header_lote: header, lotes: details, trailer_lote: footer}
     end)}
  end

  defp get_chunk_infos(header) do
    get_payment_method(header)
    %{}
  end

  defp get_payment_method(header) do
    payment_details = header.service

    payment_input = @payment_mapper[:"#{payment_details.tipo_servico}"]

    service_type = payment_input[:"#{payment_details.forma_lancamento}"] |> IO.inspect()
  end
end
