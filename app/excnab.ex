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

      def decode!(filepath, attrs \\ %{}) do
        Cnab.decode!(filepath, attrs)
      end

      def encode(params, attrs \\ %{}) do
        Cnab.encode(params, attrs)
      end

      def encode!(params, attrs \\ %{}) do
        Cnab.encode(params, attrs)
      end
    end
  end

  @doc """
  Decode a single file.
  This will decode the cnab file applying the correct format to each CNAB 240 template
  ### Example
      decode("JVH1234.rem", %{})
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

  def decode!(filepath, attrs \\ %{}) do
    ExCnab.Cnab240.Services.Decode.run!(filepath, attrs)
  end

  @doc """
  Encode a single file.
  This will encode your params to a one CNAB file applying the correct format to each CNAB 240 template
  ### Example
      encode(%{cnab: cnab}, %{filename: "JVH1010101.ret, path: "../../docs/"})
      {:ok, "../../docs/"}

      encode(%{cnab: cnab}, %{})
      {:ok, "../../default/"}

      encode!(%{cnab: cnab}, %{filename: "JVH1010101.ret, path: "../../docs/"})
      "../../docs/"

      encode!(%{cnab: cnab}, %{})
      "../../default/"
  """
  @callback encode(params :: Map.t()) :: any
  @callback encode(params :: Map.t(), attrs :: keyword | map) :: {:ok, path :: String.t()}
  def encode(params, attrs \\ %{}) do
    ExCnab.Cnab240.Services.Encode.run(params, attrs)
  end

  @callback encode(params :: Map.t()) :: any
  @callback encode(params :: Map.t(), attrs :: keyword | map) :: path :: String.t()
  def encode!(params, attrs \\ %{}) do
    ExCnab.Cnab240.Services.Encode.run!(params, attrs)
  end
end
