defmodule Day7 do

  def solve(input) do
    data = input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_rule/1)

    alphabets =
      data
      |> Enum.flat_map(fn [x,y | []] -> [x, y] end)
      |> Enum.uniq

    rules =
      data
      |> construct_steps_map

    construct_orders(alphabets, alphabets, rules, [], 0, Enum.count(alphabets))
    |> Enum.join
    |> IO.inspect

  end

  def construct_orders([h | tail], alphabets, rules, list, _, final_count) do
    list = check_dependencies(rules, h, list)
    construct_orders(tail, alphabets, rules, list, Enum.count(list), final_count)
  end

  def construct_orders(_, _, _, list, count, count), do: list
  def construct_orders(_, _, _, list, count, final_count) when count >= final_count, do: list
  def construct_orders([], alphabets, rules, list, count, final_count) do
    construct_orders(alphabets, alphabets, rules, list, count, final_count)
  end

  def check_dependencies(rules, x, list) do
    dependencies = Map.get(rules, x)
    fill_orders(x, dependencies, list)
  end


  def fill_orders(x, nil, list) do
    cond do
      x in list -> list
      true -> insert_head(x, list)
    end
  end

  def fill_orders(x, dependencies, list) do
    cond do
      x in list -> list
      includes?(list, dependencies) ->
        insert(x, list, dependencies)
      true -> list
    end
  end

  def insert_head(x, [h | tail]) do
    cond do
      x > h -> [h | insert_head(x, tail)]
      x < h -> [x, h | tail]
    end
  end
  def insert_head(x, []), do: [x]

  def insert(x, [], _), do: [x]
  def insert(x, [h | tail], []) do
    cond do
      x > h -> [h, x | tail]
      x < h -> [x, h | tail]
    end
  end
  def insert(x, [h | tail], dependencies) do
    cond do
      h in dependencies ->
        remaining = (dependencies -- [h])
        [ h | insert(x, tail, remaining)]
      true ->
        [ h | insert(x, tail, dependencies) ]
    end
  end

  def includes?(list, dependencies) do
    Enum.reduce(dependencies, true, fn x, acc ->
      Enum.any?(list, &(&1 == x)) && acc
    end)
  end

  def construct_steps_map(rules) do
    construct_steps_map(rules, %{})
  end
  def construct_steps_map([h | tail], map) when map == %{} do
    [first, second | []] = h
    construct_steps_map(tail, %{second => [first]})
  end
  def construct_steps_map([h | tail], map) do
    [first, second | []] = h
    map = Map.update(map, second, [first], fn (x) -> [first | x] end)
    construct_steps_map(tail, map)
  end
  def construct_steps_map([], map), do: map

  def parse_rule(string) do
    string
    |> String.split(["Step ", " must be finished before step ", " can begin."], trim: true)
  end
end

# test_case = """
# Step A must be finished before step B can begin.
# Step A must be finished before step D can begin.
# Step B must be finished before step E can begin.
# Step D must be finished before step E can begin.
# Step C must be finished before step A can begin.
# Step C must be finished before step F can begin.
# Step F must be finished before step E can begin.
# """

# test_case |> Day7.solve() |> Kernel.==("CABDFE") |> IO.inspect

File.read!("input.txt")
|> Day7.solve()
