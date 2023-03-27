defmodule CnabWeb.FileController do
  use Phoenix.Controller

  alias Cnab.Cnab240.Services.ProcessFile

  def validate_file_format(conn, params) do
    {:ok, parser_file} = ProcessFile.run(params["file"])

    conn
    |> put_status(:ok)
    |> json(parser_file)
  end
end

# Padrao - C (baseado em boletos)
# Padrao - Z (baseado em auteticacao)
