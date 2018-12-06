defmodule Day5 do

  def solve(string) do
    codepoints = String.codepoints(String.trim_trailing(string))
                 |> IO.inspect
    reduce(codepoints)
    |> IO.inspect
    |> Enum.count
    |> IO.inspect
  end

  def reduce(codepoints) do
    reduce(codepoints, [])
  end

  defp reduce([head | tail], []) do
    reduce(tail, [ head ])
  end


  defp reduce([head | tail], [result_head | result_tail]) do
    if react?(head, result_head) do
     reduce(tail, result_tail)
   else
     reduce(tail, [ head, result_head | result_tail ])
    end
  end

  # defguard can_react?(a, b) when abs(a - b) == 32
  # # 32 is the difference of ?a - ?A

  # defp reduce([<<head::utf8>> | tail], [<<result_head::utf8>> | result_tail]) when can_react?(head, result_head) do
  #   reduce(tail, result_tail)
  # end

  # defp reduce([head | tail], [result_head | result_tail]) do
  #   reduce(tail, [ head, result_head | result_tail ])
  # end

  defp reduce([head | []], result) do
    [ head | result ]
  end

  defp reduce([], result) do
    result
  end

  # defp reduce([a, b | tail], result) do
  #   if react?(a, b) do
  #     cond do
  #       [] == result ->
  #         reduce(tail, result)
  #       [h | t] = result ->
  #         reduce([h | tail], t)
  #     end
  #   else
  #     reduce([b | tail], [a | result])
  #   end
  # end

  defp react?(char1, char2) do
    (String.downcase(char1) == char2 || String.downcase(char2) == char1)
    && (String.upcase(char1) == char2 || String.upcase(char2) == char1)
  end
end

# test_case = "dabAAcCaCBAcCcaDA"
# test_case
# |> Day5.solve
# |> Kernel.==(11)
# |> IO.inspect

File.read!("input.txt")
|> Day5.solve
