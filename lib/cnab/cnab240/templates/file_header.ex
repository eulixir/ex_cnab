defmodule Cnab.Cnab240.Templates.FileHeader do
  @moduledoc """
  Template for rendering a cnab240 header from a file
  """

  import Helpers.ConvertPosition

  @doc """
  This function generate a Header File Map from a Cnab240 file, using the **FEBRABAN** convention. The fields follows the convention hierarchy,
  and the returns is in PT BR.

  You can see all hierarchy in the FEBRABAN documentation.

  ```md
  CNAB
  ├── Controle
  │   ├── Banco (1..3)
  │   ├── Lote (4..7)
  │   └── Registro (8..8)
  │
  ├── CNAB - USO FEBRABAN (9..17)
  │
  ├── Empresa
  │   ├── Inscrição
  │   │   ├── Tipo (18..18)
  │   │   └── Número de inscrição (19..32)
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
  │   └── Nome da empresa (73..102)
  │
  ├── Nome do banco (103..132)
  │
  ├── CNAB - USO FEBRABAN (133..142)
  │
  ├── Arquivo
  │   ├── Código remessa / retorno (143..143)
  │   ├── Data geração (144..151)
  │   ├── Hora geração (152..157)
  │   ├── Sequência - NSA (158..163)
  │   ├── Layout do arquivo (164..166)
  │   └── Densidade (167..171)
  │
  ├── Reservado banco (172..191)
  │
  ├── Reservado empresa (192..211)
  │
  └── CNAB - USO FEBRABAN (212..240)
  ```
  """

  @spec generate(String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def generate(raw_string) do
    control_fields = control_fields(raw_string)
    company_fields = company_fields(raw_string)
    about_fields = about_fields(raw_string)

    {:ok,
     %{
       controle: control_fields,
       uso_febraban_01: convert_position(raw_string, 9, 17),
       empresa: company_fields,
       nome_banco: convert_position(raw_string, 103, 132),
       uso_febraban_02: convert_position(raw_string, 133, 142),
       arquivo: about_fields,
       uso_banco: convert_position(raw_string, 172, 191),
       uso_empresa: convert_position(raw_string, 192, 211),
       uso_febraban_03: convert_position(raw_string, 212, 240)
     }}
  end

  defp control_fields(raw_string) do
    %{
      codigo_do_banco: convert_position(raw_string, 1, 3),
      lote: convert_position(raw_string, 4, 7),
      registro: convert_position(raw_string, 8, 8)
    }
  end

  defp company_fields(raw_string) do
    %{
      inscricao: %{
        tipo_inscricao_empresa: convert_position(raw_string, 18, 18),
        numero_inscricao_empresa: convert_position(raw_string, 19, 32)
      },
      codigo_convenio_no_banco: convert_position(raw_string, 33, 52),
      conta_corrente: %{
        agencia_mantedora: convert_position(raw_string, 53, 57),
        digito_verificador_agencia: convert_position(raw_string, 58, 58),
        numero_conta_corrente: convert_position(raw_string, 59, 70),
        digito_verificador_conta: convert_position(raw_string, 71, 71),
        digito_verificador_ag_conta: convert_position(raw_string, 72, 72)
      },
      nome_empresa: convert_position(raw_string, 73, 102)
    }
  end

  defp about_fields(raw_string) do
    %{
      codigo_remessa_retorno: convert_position(raw_string, 143, 143),
      data_geracao_arquivo: convert_position(raw_string, 144, 151),
      hora_geracao_arquivo: convert_position(raw_string, 152, 157),
      numero_sequencial_arquivo: convert_position(raw_string, 158, 163),
      numero_versao_leiaute: convert_position(raw_string, 164, 166),
      densidade_arquivo: convert_position(raw_string, 167, 171)
    }
  end
end
