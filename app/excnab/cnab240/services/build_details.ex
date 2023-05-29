defmodule ExCnab.Cnab240.Services.BuildDetails do
  @moduledoc """
  Service to generate a details
  """

  alias ExCnab.Cnab240.Templates.{ChunkFooter, ChunkHeader, Details}

  alias ExCnab.Cnab240.Validator.Details, as: DetailsValidator

  @payment_mapper %{
    "03": %{
      code: :boleto_eletronico,
      descricao: "Boleto Eletrônico",
      "30": %{
        code: :liquidacao_titulos_banco,
        descricao: "Liquidação de Títulos do Próprio Banco"
      },
      "31": %{
        code: :liquidacao_titulos_outros_banco,
        descricao: "Pagamento de Títulos de Outros Bancos"
      }
    },
    "20": %{
      code: :pagamento_fornecedor,
      descricao: "Pagamento Fornecedor",
      "01": %{
        code: :credito_conta,
        descricao: "Crédito em Conta-Corrente"
      },
      "03": %{
        code: :doc,
        descricao: "DOC"
      },
      "10": %{
        code: :op,
        descricao: "Ordem de Pagamento - OP"
      },
      "41": %{
        code: :ted,
        descricao: "TED - Transferência entre Clientes"
      },
      "45": %{
        code: :pix,
        descricao: "PIX - Transferência"
      }
    },
    "22": %{
      code: :pagamento_de_contas,
      descricao: "Pagamento de Contas, Tributos e Impostos",
      "11": %{
        code: :pagamento_de_contas_codigo_barras,
        descricao: "Pagamento de Contas e Tributos com Código de Barras"
      },
      "16": %{
        code: :tributo_darf_normal,
        descricao: "Tributo DARF Normal"
      },
      "17": %{
        code: :tributo_gps,
        descricao: "Tributo GPS (Guia da Previdência Social)"
      },
      "18": %{
        code: :tributo_darf_simples,
        descricao: "Tributo DARF Simples"
      }
    },
    "30": %{
      code: :pagamento_salario,
      descricao: "Pagamento Salários/Folha de Pagamento",
      "01": %{
        code: :credito_conta,
        descricao: "Crédito em Conta-Corrente"
      }
    }
  }

  @spec run(Map.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t(), String.t()}
  def run(%{chunks: batches}, _attrs) do
    with {:ok, builded_details} <- build_recursive(batches, [], batches, nil),
         {:ok, _} <- DetailsValidator.call(builded_details, batches) do
      {:ok, builded_details}
    end
  end

  defp build_recursive([], acc, _, nil), do: {:ok, acc}

  defp build_recursive([hd | tail], acc, original_batches, nil) do
    with index <- Enum.find_index(original_batches, &(&1 == hd)) + 1,
         detail_key_id <- :"chunk_register_#{index}",
         %{header: header, detail: details, footer: footer} <- hd[detail_key_id],
         {:ok, builded_header} <- ChunkHeader.generate(header),
         {:ok, builded_details} <- Details.generate(details),
         {:ok, builded_footer} <- ChunkFooter.generate(footer),
         amount <- get_chunk_infos(builded_header, builded_footer) do
      details = [
        %{
          header_lote: builded_header,
          lotes: builded_details,
          trailer_lote: builded_footer,
          valor: amount
        }
      ]

      build_recursive(tail, acc ++ details, original_batches, nil)
    end
  end

  defp get_chunk_infos(header, %{total: %{valor: amount}}) do
    %{service_type: service_type} = get_payment_method(header)

    %{tipo: service_type, quantidade: amount}
  end

  defp get_payment_method(%{servico: payment_details}) do
    payment_input = @payment_mapper[:"#{payment_details.tipo_servico}"]

    service_type = payment_input[:"#{payment_details.forma_lancamento}"]

    %{payment_input: payment_input.code, service_type: service_type.code}
  end
end
