defmodule Cnab.Cnab240.Services.VerifyFile do
  @moduledoc """
  Service to verify file and return some fields to client
  """
  alias Cnab.Cnab240.Services.ProcessFile

  @spec run(Plug.Upload.t()) :: {:ok, Map.t()} | {:error, Any.t()}
  def run(file) do
    case String.contains?(file.filename, "REM") do
      true ->
        file
        |> ProcessFile.run()
        |> build_response(file)

      false ->
        {:error, %{status: 422, message: "Check your filename, maybe something is wrong"}}
    end
  end

  defp build_response({:ok, processed_file}, %{filename: filename}) do
    client = processed_file.cnab240.arquivo_header.empresa.nome_empresa
    cooperativa = processed_file.cnab240.arquivo_header.nome_banco

    {:ok,
     %{
       cooperativa: cooperativa,
       cliente: client,
       arquivo: filename,
       credito_em_conta_corrente: "10.000R$",
       doc: "10.000R$",
       ordem_de_pagament_op: "10.000R$",
       ted: "10.000R$",
       pix: "10.000R$"
     }}
  end
end
