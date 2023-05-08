defmodule ExCnab.Cnab240.Templates.Details.ModelO do
  @moduledoc """
  Template to generate an cnab 240 object from file, following the O-segment pattern;
  """
  import Helpers.ConvertPosition

  @doc """
  This function generate a Header Chunk Map from a Cnab240 file, using the **FEBRABAN** convention. The fields follows the O-segment hierarchy,
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
  │   └── Movimento
  │         ├── Tipo (15..15)
  │         └── Código (16..17)
  │
  ├── Pagamento
  │   ├── Código Barras (18..61)
  │   │
  │   ├── Nome da Concessionária (62..91)
  │   │
  │   ├── Data vencimento (92..99)
  │   │
  │   ├── Data Pagamento (100..107)
  │   │
  │   ├── Valor pagamento (108..122)
  │   │
  │   ├── Seu número (123..142)
  │   │
  │   └── Nosso número (143..162)
  │
  ├── CNAB (163..230)
  │
  └── Ocorrências (231..240)
  """

  alias ExCnab.Cnab240.Validator.Details.ModelO, as: ModelOValidator

  @spec generate(String.t()) :: {:ok, Map.t()}
  def generate(raw_string) do
    control_field = control_field(raw_string)
    service_field = service_field(raw_string)
    payment_field = payment_field(raw_string)

    %{
      controle: control_field,
      servico: service_field,
      pagamento: payment_field,
      cnab: convert_position(raw_string, 163, 230),
      ocorrencias: convert_position(raw_string, 231, 240)
    }
    |> ModelOValidator.call(raw_string)
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
      nome_concessionaria: convert_position(raw_string, 62, 91),
      data_vencimento: convert_position(raw_string, 92, 99),
      data_pagamento: convert_position(raw_string, 100, 107),
      valor_pagamento: convert_position(raw_string, 108, 122),
      seu_numero: convert_position(raw_string, 123, 142),
      nosso_numero: convert_position(raw_string, 143, 162)
    }
  end

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
        nome_concessionaria: nome_concessionaria,
        data_vencimento: data_vencimento,
        data_pagamento: data_pagamento,
        valor_pagamento: valor_pagamento,
        seu_numero: seu_numero,
        nosso_numero: nosso_numero
      },
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
      nome_concessionaria,
      data_vencimento,
      data_pagamento,
      valor_pagamento,
      seu_numero,
      nosso_numero,
      cnab,
      ocorrencias
    ]
    |> Enum.join()
  end
end
