defmodule Cnab.Cnab240.Templates.Details.ModelA do
  @moduledoc """
  Template to generate an cnab 240 object from file, following the A-segment pattern;
  """
  import Helpers.ConvertPosition

  @doc """
  This function generate a Header Chunk Map from a Cnab240 file, using the **FEBRABAN** convention. The fields follows the A-segment hierarchy,
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
  ├── Favorecido
  │   ├── Câmara (18..20)
  │   │
  │   ├── Banco (21..23)
  │   │
  │   ├── Conta corrente
  │   │   ├── Agência
  │   │   │    ├── Código (24..28)
  │   │   │    └── DV (29..29)
  │   │   │
  │   │   ├── Conta
  │   │   │   ├── Número (30..41)
  │   │   │   └── DV (42..42)
  │   │   │
  │   │   └── DV (43..43)
  │   │
  │   ├── Nome (44..73)
  │   │
  │   └── Seu número (73..93)
  │
  ├── Credito
  │   ├── Data pagamento (94..101)
  │   │
  │   ├── Moeda
  │   │   ├── Tipo (102..104)
  │   │   │
  │   │   └── Conta (105..119)
  │   │
  │   ├── Valor Pagamento (120..134)
  │   │
  │   ├── Nosso número (135..154)
  │   │
  │   ├── Data real (155..162)
  │   │
  │   └── Valor real (163..177)
  │
  ├── Informação 2 (178..217)
  │
  ├── Codigo finalidade DOC (218..219)
  │
  ├── Código finalidade TED (220..224)
  │
  ├── Código finalidade complementar (225..226)
  │
  ├── CNAB (227..229)
  │
  ├── Aviso (230..230)
  │
  └── Ocorrências (231..240)
  """

  @spec generate(String.t()) :: {:ok, Map.t()}
  def generate(raw_string) do
    control_field = control_field(raw_string)
    service_field = service_field(raw_string)
    beneficiary_field = beneficiary_field(raw_string)
    credit_field = credit_field(raw_string)

    {:ok,
     %{
       controle: control_field,
       servico: service_field,
       favorecido: beneficiary_field,
       credito: credit_field,
       informação_02: convert_position(raw_string, 178, 217),
       codigo_finalidade_doc: convert_position(raw_string, 218, 219),
       codigo_finalidade_ted: convert_position(raw_string, 220, 224),
       codigo_finalidade_finalidade_complementar: convert_position(raw_string, 225, 226),
       cnab: convert_position(raw_string, 227, 229),
       aviso: convert_position(raw_string, 230),
       ocorrencias: convert_position(raw_string, 231, 240)
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

  defp beneficiary_field(raw_string) do
    %{
      camara: convert_position(raw_string, 18, 20),
      banco: convert_position(raw_string, 21, 23),
      conta_corrente: %{
        agencia: %{
          codigo: convert_position(raw_string, 24, 28),
          dv: convert_position(raw_string, 29)
        },
        conta: %{
          numero: convert_position(raw_string, 30, 41),
          dv: convert_position(raw_string, 42)
        },
        dv: convert_position(raw_string, 43, 43)
      },
      nome: convert_position(raw_string, 44, 73),
      seu_numero: convert_position(raw_string, 74, 93)
    }
  end

  defp credit_field(raw_string) do
    %{
      data_pagamento: convert_position(raw_string, 94, 101),
      moeda: %{
        tipo: convert_position(raw_string, 102, 104),
        quantidade: convert_position(raw_string, 105, 119)
      },
      valor_pagamento: convert_position(raw_string, 120, 134),
      nosso_numero: convert_position(raw_string, 135, 154),
      data_real: convert_position(raw_string, 155, 162),
      valor_real: convert_position(raw_string, 163, 177)
    }
  end
end
