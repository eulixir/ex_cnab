import ExCnab240

{:ok, decoded1} =
  "../documents/Senior_files/JVH06104.rem"
  |> decode(%{})
  |> IO.inspect(label: "decoded1")

decoded1.cnab240
|> encode!(%{})

{:error, _failed_encoded} =
  "../documents/banana.txt"
  |> decode(%{})

decoded1
|> find_details_type()
