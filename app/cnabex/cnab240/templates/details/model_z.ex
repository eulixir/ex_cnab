defmodule ExCnab.Cnab240.Templates.Details.ModelZ do
  @moduledoc """
  Template to generate an cnab 240 object from file, following the Z-segment pattern;
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
  │   └── Segmento (14..14)
  │
  ├── Autenticacao (15..78)
  │
  ├── Controle bancario (79..103)
  │
  ├── Reservado (104..230)
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
       autenticacao: convert_position(raw_string, 15, 78),
       controle_bancario: convert_position(raw_string, 79, 103),
       reservado: convert_position(raw_string, 104, 230),
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
      segmento: convert_position(raw_string, 14)
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
      autenticacao: autenticacao,
      controle_bancario: controle_bancario,
      reservado: reservado,
      ocorrencias: ocorrencias
    } = detail

    [
      banco,
      lote,
      registro,
      n_registro,
      segmento,
      autenticacao,
      controle_bancario,
      reservado,
      ocorrencias
    ]
    |> Enum.join()
  end
end
