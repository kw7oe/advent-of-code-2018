defmodule Day5 do
  def solve(string) do
    codepoints = String.codepoints(String.trim_trailing(string))

    codepoints
    |> remove_and_reduce
    |> Enum.min_by(fn {_k, v} -> v end)
    |> IO.inspect()
  end

  def remove_and_reduce(codepoints) do
    Enum.reduce(?a..?z, %{}, fn codepoint, map ->
      new_codepoints =
        codepoints
        |> Enum.reject(fn <<char::utf8>> ->
          diff = abs(codepoint - char)
          diff == 0 || diff == 32
        end)

      result = new_codepoints |> reduce |> Enum.count()
      Map.put(map, codepoint, result)
    end)
  end

  def reduce(codepoints) do
    reduce(codepoints, [])
  end

  defp reduce([a, b | tail], result) do
    if react?(a, b) do
      cond do
        [] == result ->
          reduce(tail, result)

        [h | t] = result ->
          reduce([h | tail], t)
      end
    else
      reduce([b | tail], [a | result])
    end
  end

  defp reduce([head | []], result) do
    [head | result]
  end

  defp reduce([], result) do
    result
  end

  defp react?(char1, char2) do
    (String.downcase(char1) == char2 || String.downcase(char2) == char1) &&
      (String.upcase(char1) == char2 || String.upcase(char2) == char1)
  end
end

# test_case = "dabAcCaCBAcCcaDA"
# test_case
# |> Day5.solve

File.read!("input.txt")
|> Day5.solve()
