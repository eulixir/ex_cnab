defmodule ExCnab.Cnab240.Templates.Details.ModelN do
  @moduledoc """
  Template to generate an cnab 240 object from file, following the N-segment pattern;
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
  │   ├── Seu numero (18..37)
  │   │
  │   ├── Nosso numero (38..57)
  │   │
  │   ├── Contribuinte (58..57)
  │   │
  │   ├── Data pagamento (88..95)
  │   │
  │   └── Valor pagamento (96..110)
  │
  ├── Informacoes complementares (111..230)
  │
  └── Ocorrências (231..240)
  """

  @spec generate(String.t()) :: {:ok, Map.t()}
  def generate(raw_string) do
    control_field = control_field(raw_string)
    service_field = service_field(raw_string)
    payment_field = payment_field(raw_string)

    complementary_info =
      raw_string
      |> convert_position(133, 134)
      |> complementary_info_fields(raw_string)

    {:ok,
     %{
       controle: control_field,
       servico: service_field,
       pagamento: payment_field,
       informacoes_complementares: complementary_info,
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

  defp payment_field(raw_string) do
    %{
      seu_numero: convert_position(raw_string, 18, 37),
      nosso_numero: convert_position(raw_string, 38, 57),
      contribuinte: convert_position(raw_string, 58, 87),
      data_pagamento: convert_position(raw_string, 88, 95),
      valor_pagamento: convert_position(raw_string, 96, 110)
    }
  end

  # DARF
  defp complementary_info_fields("16", raw_string) do
    %{
      receita: convert_position(raw_string, 111, 116),
      tipo_id_contribuinte: convert_position(raw_string, 117, 118),
      id_contribuinte: convert_position(raw_string, 119, 132),
      id_tributo: convert_position(raw_string, 133, 134),
      periodo: convert_position(raw_string, 135, 142),
      referencia: convert_position(raw_string, 143, 159),
      valor_principal: convert_position(raw_string, 158, 174),
      valor_multa: convert_position(raw_string, 175, 189),
      juros_e_encargos: convert_position(raw_string, 190, 204),
      data_vencimento: convert_position(raw_string, 205, 212),
      cnab: convert_position(raw_string, 213, 230)
    }
  end

  # GPS
  defp complementary_info_fields("17", raw_string) do
    %{
      receita: convert_position(raw_string, 111, 116),
      tipo_id_contribuinte: convert_position(raw_string, 117, 118),
      id_contribuinte: convert_position(raw_string, 119, 132),
      id_tributo: convert_position(raw_string, 133, 134),
      competencia: convert_position(raw_string, 135, 140),
      valor_tributo: convert_position(raw_string, 141, 155),
      valor_outras_entidades: convert_position(raw_string, 156, 170),
      atualizacao_monetaria: convert_position(raw_string, 171, 185),
      cnab: convert_position(raw_string, 186, 230)
    }
  end

  # DARF SIMPLES
  defp complementary_info_fields("18", raw_string) do
    %{
      receita: convert_position(raw_string, 111, 116),
      tipo_id_contribuinte: convert_position(raw_string, 117, 118),
      id_contribuinte: convert_position(raw_string, 119, 132),
      id_tributo: convert_position(raw_string, 133, 134),
      periodo: convert_position(raw_string, 135, 142),
      receita_bruta: convert_position(raw_string, 143, 157),
      percentual: convert_position(raw_string, 158, 164),
      valor_principal: convert_position(raw_string, 165, 179),
      valor_multa: convert_position(raw_string, 180, 194),
      juros_e_encargos: convert_position(raw_string, 195, 209),
      cnab: convert_position(raw_string, 210, 230)
    }
  end

  def encode(detail) do
    complementary_info =
      encode_complementary_info(detail.informacoes_complementares.id_tributo, detail)

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
        seu_numero: seu_numero,
        nosso_numero: nosso_numero,
        contribuinte: contribuinte,
        data_pagamento: data_pagamento,
        valor_pagamento: valor_pagamento
      },
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
      seu_numero,
      nosso_numero,
      contribuinte,
      data_pagamento,
      valor_pagamento,
      complementary_info,
      ocorrencias
    ]
    |> Enum.join()
  end

  defp encode_complementary_info("16", detail) do
    %{
      receita: receita,
      tipo_id_contribuinte: tipo_id_contribuinte,
      id_contribuinte: id_contribuinte,
      id_tributo: id_tributo,
      periodo: periodo,
      referencia: referencia,
      valor_principal: valor_principal,
      valor_multa: valor_multa,
      juros_e_encargos: juros_e_encargos,
      data_vencimento: data_vencimento,
      cnab: cnab
    } = detail

    [
      receita,
      tipo_id_contribuinte,
      id_contribuinte,
      id_tributo,
      periodo,
      referencia,
      valor_principal,
      valor_multa,
      juros_e_encargos,
      data_vencimento,
      cnab
    ]
    |> Enum.join()
  end

  defp encode_complementary_info("17", detail) do
    %{
      receita: receita,
      tipo_id_contribuinte: tipo_id_contribuinte,
      id_contribuinte: id_contribuinte,
      id_tributo: id_tributo,
      competencia: competencia,
      valor_tributo: valor_tributo,
      valor_outras_entidades: valor_outras_entidades,
      atualizacao_monetaria: atualizacao_monetaria,
      cnab: cnab
    } = detail

    [
      receita,
      tipo_id_contribuinte,
      id_contribuinte,
      id_tributo,
      competencia,
      valor_tributo,
      valor_outras_entidades,
      atualizacao_monetaria,
      cnab
    ]
    |> Enum.join()
  end

  defp encode_complementary_info("18", detail) do
    %{
      receita: receita,
      tipo_id_contribuinte: tipo_id_contribuinte,
      id_contribuinte: id_contribuinte,
      id_tributo: id_tributo,
      periodo: periodo,
      receita_bruta: receita_bruta,
      percentual: percentual,
      valor_principal: valor_principal,
      valor_multa: valor_multa,
      juros_e_encargos: juros_e_encargos,
      cnab: cnab
    } = detail

    [
      receita,
      tipo_id_contribuinte,
      id_contribuinte,
      id_tributo,
      periodo,
      receita_bruta,
      percentual,
      valor_principal,
      valor_multa,
      juros_e_encargos,
      cnab
    ]
    |> Enum.join()
  end
end
