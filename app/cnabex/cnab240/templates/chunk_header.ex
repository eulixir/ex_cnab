defmodule ExCnab.Cnab240.Templates.ChunkHeader do
  @moduledoc """
  Template for rendering a cnab240 chenk header from a file
  """
  import Helpers.ConvertPosition

  @doc """
  This function generate a Header Chunk Map from a Cnab240 file, using the **FEBRABAN** convention. The fields follows the convention hierarchy,
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
  │   ├── Operação (9..9)
  │   ├── Serviço (10..11)
  │   ├── Forma lançamento (12..13)
  │   └── Layout do lote (14..16)
  │
  ├── Cnab (17..17)
  │
  ├── Empresa
  │   ├── Inscrição
  │   │   ├── Tipo (18..18)
  │   │   └── Número (19..32)
  │   │
  │   ├── Convênio (33..52)
  │   │
  │   ├── Conta corrente
  │   │   ├── Agência
  │   │   │   ├── Código (53..57)
  │   │   │   └── DV (58..58)
  │   │   │
  │   │   ├── Conta
  │   │   │   └── Número DV
  │   │   │       ├── Número da conta corrente (59..70)
  │   │   │       └── Dígito verificador da conta (71..71)
  │   │   │
  │   │   └── DV (72..72)
  │   │
  │   └── Nome (73..102)
  │
  ├── CNAB - USO FEBRABAN (103..142)
  │
  ├── Endereço da empresa
  │   ├── Logadouro (143..172)
  │   ├── Número (173..177)
  │   ├── Complemento (178..192)
  │   ├── Cidade (193..212)
  │   ├── CEP (213..217)
  │   ├── Complemento CEP (218..220)
  │   └── Estado (221..222)
  │
  ├── CNAB - USO FEBRABAN (223..230)
  │
  └── Ocorrências (231..240)
  """

  @spec generate(String.t()) :: {:ok, Map.t()}
  def generate(raw_string) do
    control_context = control_fields(raw_string)
    service_context = service_fields(raw_string)
    company = company_fields(raw_string)
    company_address = company_address_fields(raw_string)

    {:ok,
     %{
       controle: control_context,
       service: service_context,
       uso_febraban_01: convert_position(raw_string, 17, 17),
       empresa: company,
       informacao: convert_position(raw_string, 103, 142),
       endereco_empresa: company_address,
       uso_febraban_02: convert_position(raw_string, 223, 230),
       ocorrencias: convert_position(raw_string, 231, 240)
     }}
  end

  defp control_fields(raw_string) do
    %{
      banco: convert_position(raw_string, 1, 3),
      lote: convert_position(raw_string, 4, 7),
      registro: convert_position(raw_string, 8, 8)
    }
  end

  defp service_fields(raw_string) do
    %{
      operacao: convert_position(raw_string, 9, 9),
      tipo_servico: convert_position(raw_string, 10, 11),
      forma_lancamento: convert_position(raw_string, 12, 13),
      layout_lote: convert_position(raw_string, 14, 16)
    }
  end

  defp company_fields(raw_string) do
    %{
      inscricao: %{
        tipo: convert_position(raw_string, 18, 18),
        numero: convert_position(raw_string, 19, 32)
      },
      convenio: convert_position(raw_string, 33, 52),
      conta_corrente: %{
        agencia: %{
          codigo: convert_position(raw_string, 53, 57),
          dv: convert_position(raw_string, 58, 58)
        },
        conta_corrente: %{
          numero: convert_position(raw_string, 59, 70),
          dv: convert_position(raw_string, 71, 71)
        },
        dv: convert_position(raw_string, 72, 72)
      },
      nome: convert_position(raw_string, 73, 102)
    }
  end

  defp company_address_fields(raw_string) do
    %{
      logradouro: convert_position(raw_string, 143, 172),
      numero: convert_position(raw_string, 173, 177),
      complemento: convert_position(raw_string, 178, 192),
      cidade: convert_position(raw_string, 193, 212),
      cep: convert_position(raw_string, 213, 217),
      complemento_cep: convert_position(raw_string, 218, 220),
      estado: convert_position(raw_string, 221, 222)
    }
  end

  @spec encode(Map.t()) :: String.t()
  def encode(params) do
    %{
      controle: %{banco: banco, lote: lote, registro: registro},
      empresa: %{
        conta_corrente: %{
          agencia: %{codigo: codigo, dv: agencia_dv},
          conta_corrente: %{dv: conta_dv, numero: numero_conta},
          dv: dv_agencia_conta
        },
        convenio: convenio,
        inscricao: %{numero: numero_inscricao, tipo: tipo_inscricao},
        nome: empresa_nome
      },
      endereco_empresa: %{
        cep: cep,
        cidade: cidade,
        complemento: complemento,
        complemento_cep: complemento_cep,
        estado: estado,
        logradouro: logradouro,
        numero: numero_endereco
      },
      informacao: informacao_01,
      ocorrencias: ocorrencias,
      service: %{
        forma_lancamento: forma_lancamento,
        layout_lote: layout_lote,
        operacao: operacao,
        tipo_servico: tipo_servico
      },
      uso_febraban_01: cnab_01,
      uso_febraban_02: cnab_02
    } = params

    [
      banco,
      lote,
      registro,
      operacao,
      tipo_servico,
      forma_lancamento,
      layout_lote,
      cnab_01,
      tipo_inscricao,
      numero_inscricao,
      convenio,
      codigo,
      agencia_dv,
      numero_conta,
      conta_dv,
      dv_agencia_conta,
      empresa_nome,
      informacao_01,
      logradouro,
      numero_endereco,
      complemento,
      cidade,
      cep,
      complemento_cep,
      estado,
      cnab_02,
      ocorrencias
    ]
    |> Enum.join()
  end
end
