defmodule ExCnab.Cnab240.Templates.Details.ModelJ do
  @moduledoc """
  Template to generate an cnab 240 object from file, following the J-segment pattern;
  """
  import Helpers.ConvertPosition

  @doc """
  This function generate a Header Chunk Map from a Cnab240 file, using the **FEBRABAN** convention. The fields follows the J-segment hierarchy,
  and the returns is in PT BR.

  You can see all hierarchy in the FEBRABAN documentation.

  ```md
  CNAB
  ├── Controle
  │   ├── Banco (1..3)
  │   ├── Lote (4..7)
  │   └── Registro (8..8)
  │
  ├── Serviço
  │   ├── N do registro (9..13)
  │   ├── Segmento (14..14)
  │   ├── CNAB (15..15)
  │   └── Cod. Mov (16..17)
  │
  ├── Pagamento
  │   ├── Código de barras (18..61)
  │   ├── Nome do beneficiário (62..91)
  │   ├── Data de vencimento (92..99)
  │   ├── Valor do título (100..114)
  │   ├── Desconto (115..129)
  │   ├── Acréscimos (130..144)
  │   ├── Data de pagamento (145..152)
  │   ├── Valor do pagamento (153..167)
  │   ├── Quantidade da moeda (168..182)
  │   └── Referência sacado (183..202)
  │
  ├── Nosso número (203..222)
  │
  ├── Código da moeda (223..224)
  │
  ├── CNAB (225..230)
  │
  └── Ocorrências (231..240)
  ```

  """

  @spec generate(String.t()) :: {:ok, Map.t()}
  def generate(raw_string) do
    control_field = control_field(raw_string)
    service_field = service_field(raw_string)
    payment_field = payment_field(raw_string)

    {:ok,
     %{
       controle: control_field,
       servico: service_field,
       pagamento: payment_field,
       nosso_numero: convert_position(raw_string, 203, 222),
       codigo_moeda: convert_position(raw_string, 223, 224),
       cnab: convert_position(raw_string, 225, 230),
       ocorrencias: convert_position(raw_string, 223, 240)
     }}
  end

  defp control_field(raw_string) do
    %{
      banco: convert_position(raw_string, 1, 3),
      lote: convert_position(raw_string, 4, 7),
      registro: convert_position(raw_string, 8)
    }
  end

  defp service_field(raw_string) do
    %{
      n_registro: convert_position(raw_string, 9, 13),
      segmento: convert_position(raw_string, 14),
      movimento: %{
        tipo: convert_position(raw_string, 15),
        codigo: convert_position(raw_string, 16, 17)
      }
    }
  end

  defp payment_field(raw_string) do
    %{
      codigo_de_barras: convert_position(raw_string, 18, 61),
      nome_beneficiario: convert_position(raw_string, 62, 91),
      data_vencimento: convert_position(raw_string, 92, 99),
      valor_do_titulo: convert_position(raw_string, 100, 114),
      desconto: convert_position(raw_string, 115, 129),
      acrescimos: convert_position(raw_string, 130, 144),
      data_pagamento: convert_position(raw_string, 145, 152),
      valor_pagamento: convert_position(raw_string, 153, 167),
      quantidade_da_moeda: convert_position(raw_string, 168, 182),
      referencia_sacado: convert_position(raw_string, 183, 202)
    }
  end

  @spec encode(detail :: Map.t()) :: String.t()
  def encode(detail) do
    %{
      controle: %{
        banco: banco,
        lote: lote,
        registro: registro
      },
      servico: %{
        n_registro: n_registro,
        segmento: segmento,
        movimento: %{
          tipo: tipo_movimento,
          codigo: codigo_movimento
        }
      },
      pagamento: %{
        codigo_de_barras: codigo_de_barras,
        nome_beneficiario: nome_beneficiario,
        data_vencimento: data_vencimento,
        valor_do_titulo: valor_do_titulo,
        desconto: desconto,
        acrescimos: acrescimos,
        data_pagamento: data_pagamento,
        valor_pagamento: valor_pagamento,
        quantidade_da_moeda: quantidade_da_moeda,
        referencia_sacado: referencia_sacado
      },
      nosso_numero: nosso_numero,
      codigo_moeda: codigo_moeda,
      cnab: cnab,
      ocorrencias: ocorrencias
    } = detail

    [
      banco,
      lote,
      registro,
      n_registro,
      segmento,
      tipo_movimento,
      codigo_movimento,
      codigo_de_barras,
      nome_beneficiario,
      data_vencimento,
      valor_do_titulo,
      desconto,
      acrescimos,
      data_pagamento,
      valor_pagamento,
      quantidade_da_moeda,
      referencia_sacado,
      nosso_numero,
      codigo_moeda,
      cnab,
      ocorrencias
    ]
    |> Enum.join()
  end
end
