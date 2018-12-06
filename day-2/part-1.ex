find_two_letter_and_three_letter = fn string ->
  values =
    string
    |> String.graphemes()
    |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, x, 1, &(&1 + 1))
    end)
    |> Map.values()

  two_letter =
    case Enum.any?(values, fn x -> x == 2 end) do
      true -> 1
      false -> 0
    end

  three_letter =
    case Enum.any?(values, fn x -> x == 3 end) do
      true -> 1
      false -> 0
    end

  %{two_letter: two_letter, three_letter: three_letter}
end

case File.read("input.txt") do
  {:ok, content} ->
    ids = content |> String.split()

    result =
      ids
      |> Enum.reduce(%{two_letter: 0, three_letter: 0}, fn x, acc ->
        result = find_two_letter_and_three_letter.(x)

        Map.merge(acc, result, fn _k, v1, v2 -> v1 + v2 end)
      end)
      |> IO.inspect()

    (Map.get(result, :two_letter) * Map.get(result, :three_letter))
    |> IO.inspect()

  {:error, _} ->
    IO.puts("Error opening file")
end
