defmodule Cnab.Repo do
  use Ecto.Repo,
    otp_app: :cnab,
    adapter: Ecto.Adapters.Postgres
end
