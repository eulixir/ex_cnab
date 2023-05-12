defmodule ExCnab.Cnab240.Templates.Details.ModelJ52 do
  @moduledoc """
  Template to generate an cnab 240 object from file, following the J 52 -segment pattern;
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
  │   └── Nome (36..75)
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
  alias ExCnab.Cnab240.Validator.Details.ModelJ52, as: ModelJ52Validator

  @spec generate(String.t()) :: {:ok, Map.t()}
  def generate(raw_string) do
    control_field = control_field(raw_string)
    service_field = service_field(raw_string)
    drawer_field = drawer_field(raw_string)
    beneficiary_field = beneficiary_field(raw_string)
    drawer_voucher_field = drawer_voucher_field(raw_string)

    %{
      controle: control_field,
      servico: service_field,
      dados_sacador: drawer_field,
      dados_beneficiario: beneficiary_field,
      dados_sacador_avalista: drawer_voucher_field,
      cod_reg: convert_position(raw_string, 18, 19),
      cnab: convert_position(raw_string, 188, 240)
    }
    |> ModelJ52Validator.call(raw_string)
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

  defp beneficiary_field(raw_string) do
    %{
      inscricao: %{
        tipo: convert_position(raw_string, 76),
        number: convert_position(raw_string, 77, 91)
      },
      nome: convert_position(raw_string, 92, 131)
    }
  end

  defp drawer_voucher_field(raw_string) do
    %{
      inscricao: %{
        tipo: convert_position(raw_string, 132),
        number: convert_position(raw_string, 133, 147)
      },
      nome: convert_position(raw_string, 148, 187)
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
        cnab: cnab_01,
        cod_mov: cod_mov
      },
      dados_sacador: %{
        inscricao: %{
          tipo: tipo_sacador,
          number: numero_sacador
        },
        nome: nome_sacador
      },
      dados_beneficiario: %{
        inscricao: %{
          tipo: tipo_beneficiario,
          number: numero_beneficiario
        },
        nome: nome_beneficiario
      },
      dados_sacador_avalista: %{
        inscricao: %{
          tipo: tipo_sacador_avalista,
          number: numero_sacador_avalista
        },
        nome: nome_sacador_avalista
      },
      cod_reg: cod_reg,
      cnab: cnab
    } = detail

    [
      banco,
      lote,
      registro,
      n_registro,
      segmento,
      cnab_01,
      cod_mov,
      cod_reg,
      tipo_sacador,
      numero_sacador,
      nome_sacador,
      tipo_beneficiario,
      numero_beneficiario,
      nome_beneficiario,
      tipo_sacador_avalista,
      numero_sacador_avalista,
      nome_sacador_avalista,
      cnab
    ]
    |> Enum.join()
  end
end
