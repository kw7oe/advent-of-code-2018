defmodule Day3 do
  def solve(input) do
    claims =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&create_claims/1)

    claims
    |> Enum.reduce(%{}, fn claim, map ->
      x = Map.get(claim, :start_x)
      end_x = Map.get(claim, :end_x)
      y = Map.get(claim, :start_y)
      end_y = Map.get(claim, :end_y)

      Enum.reduce(x..end_x, map, fn x, acc ->
        Enum.reduce(y..end_y, acc, fn y, acc_2 ->
          # IO.inspect "Inspecting #{x}, #{y}"
          Map.update(acc_2, {x, y}, 1, &(&1 + 1))
        end)
      end)
    end)
    |> Enum.filter(fn {_, x} -> x > 1 end)
    |> Enum.count()
    |> IO.inspect()

    # {x, end_x, y, end_y} = find_min_max_of_area(claims)

    # Enum.reduce(x..end_x, 0, fn (x, acc) ->
    #   count = Enum.reduce(y..end_y, 0, fn (y, acc_y) ->
    #     # IO.puts "Inspecting x: #{x}, y: #{y}..."
    #     overlap = Enum.reduce_while(claims, 0, fn (claim, count) ->
    #       new_count = if overlap?(claim, x, y) do
    #         count + 1
    #       else
    #         count
    #       end

    #       if new_count == 2 do
    #         {:halt, new_count}
    #       else
    #         {:cont, new_count}
    #       end
    #     end)

    #     add = if overlap == 2 do
    #       1
    #     else
    #       0
    #     end

    #     acc_y + add
    #   end)
    #   |> IO.inspect(label: "Count")
    #   acc + count
    # end)
  end

  # def overlap?(claim, x, y) do
  #   x >= Map.get(claim, :start_x) && x <= Map.get(claim, :end_x) &&
  #     y >= Map.get(claim, :start_y) && y <= Map.get(claim, :end_y)
  # end

  def create_claims(string) do
    [coordinates, size | []] =
      String.split(string, "@ ")
      |> List.last()
      |> String.split(": ")

    [x, y | []] = coordinates |> String.split(",") |> Enum.map(&String.to_integer/1)
    [w, h | []] = size |> String.split("x") |> Enum.map(&String.to_integer/1)

    %{start_x: x + 1, end_x: x + w, start_y: y + 1, end_y: y + h}
  end

  # def find_min_max_of_area(claims) do
  #   x = claims |> Enum.min(fn (x) -> Map.get(x, :start_x) end) |> Map.get(:start_x)
  #   y = claims |> Enum.min(fn (x) -> Map.get(x, :start_y) end) |> Map.get(:start_y)
  #   end_x = claims |> Enum.max_by(fn (x) -> Map.get(x, :end_x) end) |> Map.get(:end_x)
  #   end_y = claims |> Enum.max_by(fn (x) -> Map.get(x, :end_y) end) |> Map.get(:end_y)
  #   {x, end_x, y, end_y}
  # end
end

# test_case = "#1 @ 1,3: 4x4\n#2 @ 3,1: 4x4\n#3 @ 5,5: 2x2"
# Day3.solve(test_case)

File.read!("input.txt")
|> Day3.solve()
