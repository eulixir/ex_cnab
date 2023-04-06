import ExCnab

  {:ok, decoded1} =
    "../documents/JVH30016.txt"
    |> decode(%{})
    |> IO.inspect()


  decoded1.cnab240
  |> encode!(%{})


  {:ok, decoded2} =
    "./priv/docs/banana.rem"
    |> decode(%{})
    |> IO.inspect()


  case decoded1 == decoded2 do
    banaa -> IO.inspect(banaa)
  end
