defmodule Day6 do
  def solve(input, safe_area) do
    coordinates =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&convert_to_tuple/1)

    {min_x, min_y, max_x, max_y} =
      coordinates
      |> find_min_and_max_coordinate

    Enum.reduce(min_x..max_x, [], fn (x, acc) ->
      Enum.reduce(min_y..max_y, acc, fn (y, acc) ->

        area =
          Enum.reduce(coordinates, 0, fn (c, acc) ->
            distance = manhattan_distance({x, y}, c)
            acc + distance
          end)

        if area < safe_area do
          [ {x, y} | acc ]
        else
          acc
        end
      end)
    end)
    |> Enum.count
    |> IO.inspect
  end


  defp find_min_and_max_coordinate(coordinates) do
    min_x = Enum.min_by(coordinates, fn (c) -> elem(c, 0) end)
    min_y = Enum.min_by(coordinates, fn (c) -> elem(c, 1) end)
    max_x = Enum.max_by(coordinates, fn (c) -> elem(c, 0) end)
    max_y = Enum.max_by(coordinates, fn (c) -> elem(c, 1) end)
    {elem(min_x, 0), elem(min_y, 1), elem(max_x, 0), elem(max_y, 1)}
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

# test_case = """
# 1, 1
# 1, 6
# 8, 3
# 3, 4
# 5, 5
# 8, 9
# """

# test_case |> Day6.solve(32) |> Kernel.==(16) |> IO.inspect()

File.read!("input.txt")
|> Day6.solve(10000)
