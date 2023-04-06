defmodule ExCnab.Cnab240.Templates.Details.ModelB do
  @moduledoc """
  Template to generate an cnab 240 object from file, following the B-segment pattern;
  """
  import Helpers.ConvertPosition

  @doc """
  This function generate a Header Chunk Map from a Cnab240 file, using the **FEBRABAN** convention. The fields follows the B-segment hierarchy,
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
  │   └── Segmento (14..14)
  │
  ├── CNAB (15..17)
  │
  │── Dados complementares
  │   ├── Favorecido
  │   │   ├── Inscrição
  │   │   │   ├── Tipo (18..18)
  │   │   │   └── Número (19..32)
  │   │   │
  │   │   ├── Logradouro (33..62)
  │   │   │
  │   │   ├── Número (63..67)
  │   │   │
  │   │   ├── Complemento (68..82)
  │   │   │
  │   │   ├── Bairro (83..97)
  │   │   │
  │   │   ├── Cidade (98..117)
  │   │   │
  │   │   ├── CEP (118..122)
  │   │   │
  │   │   ├── Complemento CEP (123..125)
  │   │   │
  │   │   └── Estado (126..127)
  │   │
  │   ├── PAGTO
  │   │   │
  │   │   ├── Vencimento (128..135)
  │   │   │
  │   │   ├── Valor documento (136..150)
  │   │   │
  │   │   ├── Abatimento (151..165)
  │   │   │
  │   │   ├── Desconto (166..180)
  │   │   │
  │   │   ├── Mora (181..195)
  │   │   │
  │   │   └── Multa (196..210)
  │   │
  │   └── Cód/Doc. Favorec. (211..225)
  │
  ├── Aviso (226..226)
  │
  ├── Código UG Centralizadora (227..232)
  │
  └── Identificação do banco no SPB (233..240)
  """

  @spec generate(String.t()) :: {:ok, Map.t()}
  def generate(raw_string) do
    control_fields = control_fields(raw_string)
    service_fields = service_fields(raw_string)
    beneficiary_fields = beneficiary_fields(raw_string)
    payer_fields = payer_fields(raw_string)

    {:ok,
     %{
       controle: control_fields,
       servico: service_fields,
       cnab: convert_position(raw_string, 15, 17),
       dados_complementares: %{
         favorecido: beneficiary_fields,
         pagto: payer_fields,
         cod_favorecido: convert_position(raw_string, 211, 225)
       },
       aviso: convert_position(raw_string, 226, 226),
       codigo_ug_centralizadora: convert_position(raw_string, 227, 232),
       id_banco_spb: convert_position(raw_string, 233, 240)
     }}
  end

  defp control_fields(raw_string) do
    %{
      banco: convert_position(raw_string, 1, 3),
      lote: convert_position(raw_string, 4, 7),
      registro: convert_position(raw_string, 8)
    }
  end

  defp service_fields(raw_string) do
    %{
      n_registro: convert_position(raw_string, 9, 13),
      segmento: convert_position(raw_string, 14)
    }
  end

  defp beneficiary_fields(raw_string) do
    %{
      inscricao: %{
        tipo: convert_position(raw_string, 18),
        numero: convert_position(raw_string, 19, 32)
      },
      logradouro: convert_position(raw_string, 33, 62),
      numero: convert_position(raw_string, 63, 97),
      complemento: convert_position(raw_string, 98, 117),
      bairro: convert_position(raw_string, 83, 97),
      cidade: convert_position(raw_string, 98, 117),
      cep: convert_position(raw_string, 118, 122),
      complemento_cep: convert_position(raw_string, 123, 125),
      estado: convert_position(raw_string, 126, 127)
    }
  end

  defp payer_fields(raw_string) do
    %{
      vencimento: convert_position(raw_string, 128, 135),
      valor_documento: convert_position(raw_string, 136, 150),
      abatimento: convert_position(raw_string, 151, 165),
      desconto: convert_position(raw_string, 166, 180),
      mora: convert_position(raw_string, 181, 195),
      multa: convert_position(raw_string, 196, 210)
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
        segmento: segmento
      },
      cnab: cnab_01,
      dados_complementares: %{
        favorecido: %{
          inscricao: %{
            tipo: tipo_inscicao,
            numero: numero_inscricao
          },
          logradouro: logradouro,
          numero: numero,
          complemento: complemento,
          bairro: bairro,
          cidade: cidade,
          cep: cep,
          complemento_cep: complemento_cep,
          estado: estado
        },
        pagto: %{
          vencimento: vencimento,
          valor_documento: valor_documento,
          abatimento: abatimento,
          desconto: desconto,
          mora: mora,
          multa: multa
        },
        cod_favorecido: cod_favorecido
      },
      aviso: aviso,
      codigo_ug_centralizadora: codigo_ug_centralizadora,
      id_banco_spb: id_banco_spb
    } = detail

    [
      banco,
      lote,
      registro,
      n_registro,
      segmento,
      cnab_01,
      tipo_inscicao,
      numero_inscricao,
      logradouro,
      numero,
      complemento,
      bairro,
      cidade,
      cep,
      complemento_cep,
      estado,
      vencimento,
      valor_documento,
      abatimento,
      desconto,
      mora,
      multa,
      cod_favorecido,
      aviso,
      codigo_ug_centralizadora,
      id_banco_spb
    ]
    |> Enum.join()
  end
end
