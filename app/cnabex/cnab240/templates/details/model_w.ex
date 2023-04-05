defmodule ExCnab.Cnab240.Templates.Details.ModelW do
  @moduledoc """
  Template to generate an cnab 240 object from file, following the W-segment pattern;
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

  @spec generate(String.t()) :: {:ok, Map.t()}
  def generate(raw_string) do
    control_field = control_field(raw_string)
    service_field = service_field(raw_string)

    {:ok,
     %{
       controle: control_field,
       servico: service_field,
       complemento_registro: convert_position(raw_string, 15),
       cnidentifica_infomacoes_1_e_2: convert_position(raw_string, 16),
       infomraca_complementar_1: convert_position(raw_string, 17, 96),
       infomraca_complementar_2: convert_position(raw_string, 87, 176),
       infomraca_complementar_3: %{identificador_tributo: convert_position(raw_string, 177, 178), informacao_complementar_tributo: convert_position(raw_string, 179, 226)},
       reservado: convert_position(raw_string, 229, 230),
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
    }
  end
end
