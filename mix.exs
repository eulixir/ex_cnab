defmodule Cnab.MixProject do
  use Mix.Project

  def project do
    [
      app: :cnab,
      version: "0.0.1",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: description(),
      aliases: aliases(),
      package: package(),
      licenses: ["MIT"],
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Cnab.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp description() do
    "A CNAB file helper. This library aims to help your bank or cooperative read, decode, display,
    and perform various operations on a CNAB file.

    Supported operations:
    - Read CNAB240 file
    - Return some data"
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.2"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_dashboard, "~> 0.7.2"},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README LICENSE*
                 CHANGELOG),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/joaopelaves/cnab"}
    ]
  end
end
