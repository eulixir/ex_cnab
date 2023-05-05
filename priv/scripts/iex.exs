import ExCnab240

  {:ok, decoded1} =
    "../documents/JVH06102.rem"
    |> decode(%{})

  decoded1.cnab240
  |> encode!(%{})

  {:error, _failed_encoded}= "../documents/banana.txt"
  |> decode(%{})

  decoded1
  |> find_details_type()
