accumulate_frequencies = fn (frequencies, initial, past_frequencies) ->
  frequencies
  |> Enum.reduce_while({initial, past_frequencies}, fn (x, {acc, appeared_frequencies})  ->
    new_frequency = x + acc

    if Enum.member?(appeared_frequencies, new_frequency) do
      {:halt, new_frequency}
    else
      appeared_frequencies = [ new_frequency | appeared_frequencies ]
      {:cont, {new_frequency, appeared_frequencies}}
    end

  end)
end

find_first_duplicate_frequency = fn (func, frequencies, initial, past_frequencies) ->
  case accumulate_frequencies.(frequencies, initial, past_frequencies) do
    {result, appeared_frequencies} ->
      func.(func, frequencies, result, appeared_frequencies)
    result -> result
  end
end

case File.read("input.txt") do
  {:ok, content} ->
    frequencies = content
                  |> String.split()
                  |> Enum.map(&String.to_integer/1)

                  find_first_duplicate_frequency.(find_first_duplicate_frequency, frequencies, 0, [0]) |> IO.inspect
  {:error, _} -> IO.puts "Error opening files"
end
