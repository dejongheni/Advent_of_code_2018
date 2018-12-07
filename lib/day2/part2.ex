defmodule Aoc2018.Day2_2 do
  import Aoc2018

  def search_box(input) do
    formatted_input = input
    |> input_string
    |> Enum.map(fn string -> String.graphemes(string) end)

    formatted_input
    |> Enum.map(fn string ->
        Enum.map(formatted_input, fn string_compared ->
            compare_lists(string, string_compared)
          end)
        |> Enum.filter(fn x -> !Enum.empty?(x) end)
      end)
    |> Enum.filter(fn x -> !Enum.empty?(x) end)
    |> Enum.uniq
    |> Enum.map(fn x -> Enum.join(x) end)
    |> Enum.filter(fn x -> String.length(x) >= 25 end)
  end

  defp compare_lists(list1, list2) do
    if length(list1 -- list2) == 1 do
      intersection(list1, list2)
    else
      []
    end
  end

  defp intersection([hd1 | tl1], [hd2 | tl2]) do
    if hd1 == hd2 do
      [hd1 | intersection(tl1, tl2)]
    else
      intersection(tl1, tl2)
    end
  end

  defp intersection([], []) do
    []
  end
end
