defmodule Day4 do
  def solve(input) do
    data =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&extract_guard_id/1)
      |> Enum.sort()
      |> Enum.reduce({nil, %{}}, &accumulate_sleep_time/2)
      |> elem(1)

    {most_sleep_id, _most_sleep_time} =
      data
      |> Enum.reduce(%{}, &sum_sleep_time/2)
      |> Enum.max_by(fn {_key, value} -> value end)

    most_sleep_minute =
      Map.fetch!(data, most_sleep_id)
      |> Enum.chunk_every(2)
      |> Enum.reduce(%{}, fn list, map ->
        [start, endd | []] = list

        Enum.reduce((start - 1)..(endd * -1), map, fn x, map ->
          # IO.inspect(x)
          Map.update(map, x, 1, &(&1 + 1))
        end)
      end)
      |> Enum.max_by(fn {_k, v} -> v end)
      |> elem(0)

    (String.to_integer(most_sleep_id) * most_sleep_minute)
    |> IO.inspect()
  end

  def sum_sleep_time({key, value}, acc) do
    Map.put(acc, key, Enum.sum(value))
  end

  def accumulate_sleep_time(datum, {current_id, map}) do
    id = Map.fetch!(datum, "id")

    if id == "" do
      {_pop, map} =
        Map.get_and_update!(map, current_id, fn list ->
          minute = Map.fetch!(datum, "minute")
          {list, [minute | list]}
        end)

      {current_id, map}
    else
      map = Map.put_new(map, id, [])
      {id, map}
    end
  end

  def extract_guard_id(string) do
    regex =
      ~r/(?<datetime>\d{4}-\d{2}-\d{2} \d+:(?<minute>\d+)).*(#(?<id>\d+)|(?<status>falls|wakes))/

    result = regex |> Regex.named_captures(string)

    case Map.fetch!(result, "status") do
      "falls" -> %{result | "minute" => String.to_integer(Map.fetch!(result, "minute")) * -1}
      "wakes" -> %{result | "minute" => String.to_integer(Map.fetch!(result, "minute"))}
      "" -> result
    end
  end
end

# test_case = """
# [1518-11-01 00:05] falls asleep
# [1518-11-01 00:25] wakes up
# [1518-11-01 00:30] falls asleep
# [1518-11-01 00:55] wakes up
# [1518-11-03 00:24] falls asleep
# [1518-11-02 00:40] falls asleep
# [1518-11-01 23:58] Guard #99 begins shift
# [1518-11-01 00:00] Guard #10 begins shift
# [1518-11-04 00:46] wakes up
# [1518-11-02 00:50] wakes up
# [1518-11-03 00:05] Guard #10 begins shift
# [1518-11-03 00:29] wakes up
# [1518-11-04 00:02] Guard #99 begins shift
# [1518-11-04 00:36] falls asleep
# [1518-11-05 00:55] wakes up
# [1518-11-05 00:03] Guard #99 begins shift
# [1518-11-05 00:45] falls asleep
# """
# Day4.solve(test_case)

File.read!("input.txt")
|> Day4.solve()
