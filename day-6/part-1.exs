defmodule Day6 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&convert_to_tuple/1)
    |> IO.inspect()
  end

  defp convert_to_tuple(string) do
    string
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def manhattan_distance({x, y}, {a, b}) do
    abs(x - a) + abs(y - b)
  end
end

test_case = """
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
"""

test_case |> Day6.solve() |> Kernel.==(17) |> IO.inspect()

# File.read!("input.txt")
# |> Day6.solve
