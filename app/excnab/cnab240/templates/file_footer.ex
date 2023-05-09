defmodule ExCnab.Cnab240.Templates.FileFooter do
  @moduledoc """
  Template for rendering a cnab240 footer from a file
  """

  import Helpers.ConvertPosition

  @doc """
  This function generate a Footer Map from a Cnab240 file, using the **FEBRABAN** convention. The fields follows the convention hierarchy.
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
  ├── Totais
  │   ├── Qtde. de lotes (18..23)
  │   ├── Qtde. de registros (24..29)
  │   └── Qtde. de contas concil (30..35)
  │
  └── CNAB - USO FEBRABAN (36..240)
  ```
  """

  alias ExCnab.Cnab240.Validator.FileFooter, as: FileFooterValidator

  @spec generate(String.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def generate(raw_string, _attrs) do
    info = info_fields(raw_string)
    total = total_fields(raw_string)

    %{
      controle: info,
      uso_febraban_01: convert_position(raw_string, 9, 17),
      total: total,
      uso_febraban_02: convert_position(raw_string, 36, 240)
    }
    |> FileFooterValidator.call(raw_string)
  end

  defp info_fields(raw_string) do
    %{
      codigo_do_banco: convert_position(raw_string, 1, 3),
      lote: convert_position(raw_string, 4, 7),
      registro: convert_position(raw_string, 8, 8)
    }
  end

  defp total_fields(raw_string) do
    %{
      qnt_lotes: convert_position(raw_string, 18, 23),
      qnt_registros: convert_position(raw_string, 24, 29),
      contas_para_conc: convert_position(raw_string, 30, 35)
    }
  end

  @spec encode(footer :: Map.t()) :: String.t()
  def encode(params) do
    %{
      controle: %{codigo_do_banco: codigo_do_banco, lote: lote, registro: registro},
      total: %{
        contas_para_conc: contas_para_conc,
        qnt_lotes: qnt_lotes,
        qnt_registros: qnt_registros
      },
      uso_febraban_01: uso_febraban_01,
      uso_febraban_02: uso_febraban_02
    } = params

    [
      codigo_do_banco,
      lote,
      registro,
      uso_febraban_01,
      qnt_lotes,
      qnt_registros,
      contas_para_conc,
      uso_febraban_02
    ]
    |> Enum.join()
  end
end
