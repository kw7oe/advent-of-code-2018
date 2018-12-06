defmodule Day3 do
  def solve(data) do
    claims =
      data
      |> String.split("\n", trim: true)
      |> Enum.map(&create_claim/1)

    map =
      claims
      |> Enum.reduce(%{}, fn claim, map ->
        x = Map.get(claim, :start_x)
        end_x = Map.get(claim, :end_x)
        y = Map.get(claim, :start_y)
        end_y = Map.get(claim, :end_y)

        Enum.reduce(x..end_x, map, fn x, acc ->
          Enum.reduce(y..end_y, acc, fn y, acc_2 ->
            Map.update(acc_2, {x, y}, 1, &(&1 + 1))
          end)
        end)
      end)

    claims
    |> Enum.reduce_while(false, fn claim, _acc ->
      x = Map.get(claim, :start_x)
      end_x = Map.get(claim, :end_x)
      y = Map.get(claim, :start_y)
      end_y = Map.get(claim, :end_y)
      id = Map.get(claim, :id)

      result =
        Enum.reduce_while(x..end_x, false, fn x, _ ->
          result =
            Enum.reduce_while(y..end_y, false, fn y, _ ->
              count = Map.get(map, {x, y})
              # IO.puts("Id: #{id}: #{x}, #{y}\n-> Count: #{count}")
              if count > 1 do
                {:halt, false}
              else
                {:cont, true}
              end
            end)

          if !result do
            {:halt, false}
          else
            {:cont, true}
          end
        end)

      if result do
        {:halt, id}
      else
        {:cont, false}
      end
    end)
  end

  def create_claim(string) do
    [id | tail] = String.split(string, " @ ")

    [coordinates, size | []] =
      tail
      |> List.last()
      |> String.split(": ")

    [x, y | []] = coordinates |> String.split(",") |> Enum.map(&String.to_integer/1)
    [w, h | []] = size |> String.split("x") |> Enum.map(&String.to_integer/1)

    %{id: id, start_x: x + 1, end_x: x + w, start_y: y + 1, end_y: y + h}
  end
end

# test_case = "#1 @ 1,3: 4x4\n#2 @ 3,1: 4x4\n#3 @ 5,5: 2x2"
# Day3.solve(test_case) |> IO.inspect

File.read!("input.txt") |> Day3.solve() |> IO.inspect()
