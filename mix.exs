defmodule ExCnab.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_cnab,
      version: "1.2.1",
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
      mod: {ExCnab.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp description() do
    "A CNAB file helper. This library aims to help your bank or cooperative read, decode, display,
    and perform various operations on a CNAB file.

    Supported operations:
    - Read CNAB240 file
    - Return some data
    - Get details type"
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["app", "test/support"]
  defp elixirc_paths(_), do: ["app"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
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
      setup: ["deps.get"],
      test: ["test"],
      scripts: ["run -r \"priv/scripts/**/*.exs\""]
    ]
  end

  defp package() do
    [
      files: ~w(app .formatter.exs mix.exs README.md LICENSE*
                 CHANGELOG),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/joaopealves/ex_cnab"}
    ]
  end
end
