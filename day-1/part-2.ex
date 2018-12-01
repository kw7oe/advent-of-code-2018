defmodule Finder do

  def is_duplicate?(frequency, appeared_frequencies) do
    # if Enum.member?(appeared_frequencies, frequency) do
    if Map.has_key?(appeared_frequencies, frequency) do
      {:halt, frequency}
    else
      # appeared_frequencies = [ frequency | appeared_frequencies ]
      appeared_frequencies = Map.put(appeared_frequencies, frequency, 0)
      {:cont, {frequency, appeared_frequencies}}
    end
  end

  def accumulate_and_find(frequencies, initial, past_frequencies) do
    frequencies
    |> Enum.reduce_while({initial, past_frequencies},
      fn (x, {prev_frequency, appeared_frequencies})  ->
        new_frequency = x + prev_frequency
        is_duplicate?(new_frequency, appeared_frequencies)
      end)
  end

  def find_first_duplicate_frequency(frequencies, initial, past_frequencies) do
    case accumulate_and_find(frequencies, initial, past_frequencies) do
      {result, appeared_frequencies} ->
        find_first_duplicate_frequency(frequencies, result, appeared_frequencies)
      result -> result
    end
  end
end


case File.read("input.txt") do
  {:ok, content} ->
    frequencies = content
                  |> String.split()
                  |> Enum.map(&String.to_integer/1)

    Finder.find_first_duplicate_frequency(frequencies, 0, %{0 => 0})
    # Finder.find_first_duplicate_frequency(frequencies, 0, [0])
    |> IO.inspect
  {:error, _} -> IO.puts "Error opening files"
end
