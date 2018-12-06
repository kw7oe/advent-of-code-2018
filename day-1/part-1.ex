case File.read("input.txt") do
  {:ok, content} ->
    content
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
    |> IO.inspect()

  {:error, _} ->
    IO.puts("Error opening files")
end
