import ExCnab

  {:ok, decoded1} =
    "../documents/JVH30016.txt"
    |> decode(%{})

  decoded1.cnab240
  |> encode!(%{})

  {:ok, decoded2} =
    "./priv/docs/banana.rem"
    |> decode(%{})

  case decoded1 == decoded2 do
    banaa -> IO.inspect(banaa)
  end
