defmodule ExCnab do
  @moduledoc """
  Cnab keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defmacro __using__(_opts) do
    quote do
      @before_compile unquote(__MODULE__)

      import CnabParser

      def decode(filepath, attrs \\ %{}) do
        Cnab.decode(filepath, attrs)
      end

      def get_decoded_file(filepath, attrs \\ %{}) do
        Cnab.get_decoded_file(filepath, attrs)
      end
    end
  end

  @doc """
  Decode a single file.
  This will decode the cnab file applying the correct format to each CNAB 240 template
  ### Example
      decode("JVH1234.rem")
      {:ok, %{
        header: %{
          # Content
        },
        details: %{
          # Content
        },
        footer: %{
          # Content
        },
        additional_info: %{
          # Content
        }
      }}
  """
  @callback decode(filepath :: String.t()) :: any
  @callback decode(filepath :: String.t(), attrs :: keyword | map) :: any
  def decode(filepath, attrs \\ %{}) do
    ExCnab.Cnab240.Services.Decode.run(filepath, attrs)
  end

  @doc """
  Decode a single file.
  This return an short info about the cnab file
  ### Example
      decode("JVH30016.txt")
      {:ok,
        %{
        arquivo: "JVH30016.txt",
        cliente: "JHON DOE",
        cooperativa: "BANCO X",
        totais: %{
          credito_conta: 10600,
          doc: 0,
          liquidacao_titulos_banco: 484686,
          liquidacao_titulos_outros_banco: 745483,
          op: 0,
          pagamento_de_contas_codigo_barras: 42949,
          pix: 0,
          ted: 20567976
        }
      }}
  """
  @callback get_decoded_file(filepath :: String.t()) :: {:ok, Map.t()}
  @callback get_decoded_file(filepath :: String.t(), attrs :: keyword | map) :: {:ok, Map.t()}
  def get_decoded_file(filepath, attrs \\ %{}) do
    ExCnab.Cnab240.Services.VerifyFile.run(filepath, attrs)
  end
end
