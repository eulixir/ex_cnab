import ExCnab

  {:ok, decoded} =
    "../documents/JVH30016.txt"
    |> decode(%{})


  decoded.cnab240.arquivo_header
  |> encode!(%{})
  |> ExCnab.Cnab240.Templates.FileHeader.generate(%{})
  |> IO.inspect()
