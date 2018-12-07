defmodule Aoc2018.Day2_1 do
  import Aoc2018
  def checksum(input) do
    map_of_1_and_2 = input
    |> input_string
    |> Enum.map(fn string -> count_occurences(string) end)
    |> Enum.reduce(%{two: 0, three: 0}, fn x, map_of_values ->
      Map.update(map_of_values, :two, 0, &(&1 + elem(x, 0)))
      |> Map.update(:three, 0,&(&1 + elem(x, 1)))
     end)
    map_of_1_and_2.two * map_of_1_and_2.three
  end

  defp count_occurences(string) do
    string
    |> String.graphemes
    |> Enum.sort
    |> Enum.chunk_by(fn char -> char end)
    |> Enum.map(fn char_list -> length(char_list) end)
    |> is_there_2_or_3
  end

  defp is_there_2_or_3(list) do
    {if Enum.member?(list, 2) do 1 else 0 end,
    if Enum.member?(list, 3) do 1 else 0 end}
  end
end
