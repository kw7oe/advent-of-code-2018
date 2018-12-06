defmodule Solver do

  def solve do
    case File.read("input.txt") do
      {:ok, content} ->
        ids = content |> String.split()

        ids
        |> Enum.reduce_while([], fn (x, acc) ->
          rest_of_ids = ids -- [x]

          result = rest_of_ids
                  |> Enum.reduce_while(:not_found, fn (y, acc) ->
                    case find_common_letter(x, y) do
                      :not_found -> {:cont, acc}
                      answer -> {:halt, answer}
                    end
                  end)


          case result do
            :not_found -> {:cont, acc}
            answer -> {:halt, answer}
          end
        end)
        |> IO.inspect

      {:error, _} -> IO.puts "Error opening file"
    end
  end

  def find_common_letter(string1, string2) do
    graphmes_one = String.graphemes(string1)
    graphmes_two = String.graphemes(string2)

    differences = graphmes_one
                  |> Enum.with_index()
                  |> Enum.filter(fn ({value, index}) ->
                    value != Enum.at(graphmes_two, index)
                  end)
                  |> Enum.map(fn ({value, _index}) -> value end)



    cond do
      Enum.count(differences) == 1 ->
        # graphmes_two |> IO.inspect
        # graphmes_one |> IO.inspect
        # differences |> IO.inspect
        (graphmes_one -- differences)
        |> Enum.join()
      true -> :not_found
    end
  end

end

Solver.solve()
# Solver.find_common_letter("fgijk", "fgujk") |> IO.inspect
# Solver.find_common_letter("lsrivfotzbdxpkgnaqmunegchj", "lsrivnotzbdxpkenaqmufrgchj") |> IO.inspect

