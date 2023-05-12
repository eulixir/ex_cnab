# ExCnab

ExCnab makes it easy to read and process CNAB files.

> **This README follows the main branch, which may not be the currently published version**. Here are the
> [docs for the latest published version of ExCnab](https://hexdocs.pm/ex_cnab/ExCnab240.html).

## Installation

#### To install in all environments (useful for generating seed data in dev/prod):

In `mix.exs`, add the ExMachina dependency:

```elixir
def deps do
  [
    {:ex_cnab, "~> 1.2.4"},
  ]
end
```

## Overview

[Check out the docs](https://hexdocs.pm/ex_cnab/ExCnab240.html) for more details.

Read and Build info from file:

```elixir
defmodule MyApp.CnabParser do
  import ExCnab240

  def run(filepath), do: decode(filepath, %{})
end

output:

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
```

```elixir
defmodule MyApp.CnabParser do
  import ExCnab240

  def run(decoded_cnab), do: encode(decoded_cnab, %{})
end

output:

    {:ok, %{content: "xxxx...", filename: "JHVAABBDD.ret"}}
```

```elixir
defmodule MyApp.GetDetailsType do
  import ExCnab240

  def run(decoded_cnab), do: find_details_type(cnab_file)

end

output:

     ["A", "B"]
```

## Contributing

Before opening a pull request, please open an issue first.

    $ git clone https://github.com/joaopealves/ex_cnab.git
    $ cd ex_cnab
    $ mix deps.get
    $ mix test

Once you've made your additions and `mix test` passes, go ahead and open a PR!

## License

ExCnab is Copyright © 2023 João Pedro Alves. It is free software, and may be
redistributed under the terms specified in the [LICENSE](/LICENSE) file.
