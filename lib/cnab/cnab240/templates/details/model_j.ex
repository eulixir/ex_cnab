defmodule Cnab.Cnab240.Templates.Details.ModelJ do
  @moduledoc """
  Template to generate an cnab 240 object from file, following the A-segment pattern;
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
  ├── Cod Reg. Opcional (18..19)
  │
  ├── Dados sacador/pagador
  │   ├── Inscrição
  │   │   ├── Tipo (20..20)
  │   │   └── Número (21..35)
  │   │
  │   └── Nome (56..75)
  │
  ├── Dados beneficiario
  │   ├── Inscrição
  │   │   ├── Tipo (76..76)
  │   │   └── Número (77..91)
  │   │
  │   └── Nome (92..131)
  │
  ├── Dados sacador avalista
  │   ├── Inscrição
  │   │   ├── Tipo (132..132)
  │   │   └── Número (133..147)
  │   │
  │   └── Nome (148..187)
  │
  └── CNAB (188..240)
  """

  @spec generate(String.t()) :: {:ok, Map.t()}
  def generate(raw_string) do
    control_field = control_field(raw_string)
    service_field = service_field(raw_string)
    drawer_field = drawer_field(raw_string)
    beneficiary_field = beneficiary_field(raw_string)
    drawer_voucher_field = drawer_voucher_field(raw_string)

    {:ok,
     %{
       controle: control_field,
       servico: service_field,
       dados_sacador: drawer_field,
       dados_beneficiario: beneficiary_field,
       dados_sacador_avalista: drawer_voucher_field,
       cod_reg: convert_position(raw_string, 18, 19),
       cnab: convert_position(raw_string, 188, 240)
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
      cnab: convert_position(raw_string, 15),
      cod_mov: convert_position(raw_string, 16, 17)
    }
  end

  defp drawer_field(raw_string) do
    %{
      inscricao: %{
        tipo: convert_position(raw_string, 20),
        number: convert_position(raw_string, 21, 35)
      },
      nome: convert_position(raw_string, 36, 75)
    }
  end

  defp drawer_voucher_field(raw_string) do
    %{
      inscricao: %{
        tipo: convert_position(raw_string, 76),
        number: convert_position(raw_string, 77, 91)
      },
      nome: convert_position(raw_string, 92, 131)
    }
  end

  defp beneficiary_field(raw_string) do
    %{
      inscricao: %{
        tipo: convert_position(raw_string, 132),
        number: convert_position(raw_string, 133, 147)
      },
      nome: convert_position(raw_string, 148, 187)
    }
  end
end
