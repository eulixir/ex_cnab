import ExCnab

  {:ok, decoded1} =
    "../documents/JVH05041742.RET"
    |> decode(%{})

  decoded1.cnab240
  |> encode!(%{})

  "../documents/banana.txt"
  |> decode(%{})
