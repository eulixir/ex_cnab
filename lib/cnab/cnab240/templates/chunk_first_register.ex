defmodule Cnab.Cnab240.Templates.ChunkFirstRegister do
  @moduledoc """

  """
  alias Cnab.Cnab240.Templates.Details.ModelA
  import Helpers.ConvertPosition

  @payment_type %{
    "03": %{
      "30": %{
        segmento: :j,
        descricao: "Liquidação de Títulos do Próprio Banco"
      },
      "31": %{
        segmento: :j,
        descricao: "Pagamento de Títulos de Outros Bancos"
      },
      descricao: "Boleto Eletrônico"
    },
    "20": %{
      "01": %{
        segmento: :ab,
        descricao: "Crédito em Conta-Corrente"
      },
      "03": %{
        segmento: :ab,
        descricao: "DOC"
      },
      "10": %{
        segmento: :ab,
        descricao: "Ordem de Pagamento - OP"
      },
      "41": %{
        segmento: :ab,
        descricao: "TED - Transferência entre Clientes"
      },
      "45": %{
        segmento: :ab,
        descricao: "PIX - Transferência"
      },
      descricao: "Pagamento Fornecedor"
    },
    "22": %{
      "11": %{
        segmento: :o,
        descricao: "Pagamento de Contas e Tributos com Código de Barras"
      },
      "16": %{
        segmento: :n,
        descricao: "Tributo DARF Normal"
      },
      "17": %{
        segmento: :n2,
        descricao: "Tributo GPS (Guia da Previdência Social)"
      },
      "18": %{
        segmento: :n3,
        descricao: "Tributo DARF Simples"
      },
      descricao: "Pagamento de Contas, Tributos e Impostos"
    },
    "30": %{
      "01": %{
        segmento: :ab,
        descricao: "Crédito em Conta-Corrente"
      },
      descricao: "Pagamento Salários/Folha de Pagamento"
    }
  }

  # @spec generate(List.t()) :: {:ok, List.t(Map.t())}
  def generate(details) do
    formated_details =
      Enum.map(details, fn register_detail ->
        {:ok, detail_object} =
          register_detail
          |> get_payment_segment()
          |> generate_payment_template(register_detail)

        detail_object
      end)

    {:ok, formated_details}
  end

  defp get_payment_segment(regsiter_detail) do
    service_type = convert_position(regsiter_detail, 10, 11)

    launch_type = convert_position(regsiter_detail, 12, 13)

    service_type
    |> IO.inspect()

    @payment_type[:"#{service_type}"][:"#{launch_type}"][:segmento]
  end

  defp generate_payment_template(:ab, regsiter_detail), do: ModelA.generate(regsiter_detail)

  # defp generate_payment_template(_, regsiter_detail), do: ModelA.generate(regsiter_detail)
end
