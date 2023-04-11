defmodule ExCnab.Cnab240.Services.Encode do
  @moduledoc """
  Service to encode a txt CNAB 240.
  """

  alias ExCnab.Cnab240.Services.EncodeDetails
  alias ExCnab.Cnab240.Templates.Footer
  alias ExCnab.Cnab240.Templates.FileHeader

  @spec run(params :: Map.t(), attrs :: Map.t()) :: {:ok, String.t()}
  def run(%{arquivo_header: header, details: details, trailer: footer}, attrs) do
    raw = encode_content(header, details, footer)

    path =
      header.empresa.codigo_convenio_banco
      |> String.trim(" ")
      |> build_filename(attrs)
      |> create_file(raw, attrs)

    {:ok, path}
  end

  @spec run!(params :: Map.t(), attrs :: Map.t()) :: String.t()
  def run!(%{arquivo_header: header, detalhes: details, trailer: footer}, attrs) do
    raw = encode_content(header, details, footer)

    header.empresa.codigo_convenio_banco
    |> String.trim(" ")
    |> build_filename(attrs)
    |> create_file(raw, attrs)
  end

  defp encode_content(header, details, footer) do
    encoded_header = FileHeader.encode(header)
    encoded_details = EncodeDetails.run(details)
    encoded_footer = Footer.encode(footer)

    [encoded_header, encoded_details, encoded_footer, ""] |> Enum.join("\r\n")
  end

  defp build_filename(_code, %{filename: filename}), do: filename

  defp build_filename(code, _attrs) do
    %{hour: hour, minute: minute, month: month, day: day} =
      DateTime.utc_now() |> DateTime.add(-3, :hour)

    [code, day, month, hour, minute, ".RET"] |> Enum.join()
  end

  defp create_file(filename, raw, %{path: path}) do
    File.rm("#{path}#{filename}")
    File.write("#{path}#{filename}", raw)

    path
  end

  @path "./priv/docs/banana.rem"
  defp create_file(filename, raw, _attrs) do
    File.rm("#{@path}#{filename}")
    File.write("#{@path}#{filename}", raw)

    @path
  end
end
