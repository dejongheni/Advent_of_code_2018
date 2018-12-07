defmodule Aoc2018.Day3_2 do
  import Aoc2018
  def non_overlapping_tile(input) do
    input
    |> input_string
    |> Aoc2018.Day3_1.format_string_to_tissue
    |> cut_tissue
    |> get_non_overlapping
  end

  defp get_non_overlapping({_mapSet1, _mapSet2, map_to_search}) do
    {setUniq, setMultiples} =
        Enum.reduce(map_to_search, {MapSet.new(), MapSet.new()},
          fn {_key, value}, {setUniq, setMultiples} ->
            if length(value) == 1 do
              {MapSet.union(setUniq, MapSet.new(value)), setMultiples}
            else
              {setUniq, MapSet.union(setMultiples, MapSet.new(value))}
            end
          end
        )
    MapSet.difference(setUniq, setMultiples)
  end

  defp cut_tissue(list_of_tissues) do
   list_of_tissues
   |> Enum.reduce({MapSet.new(), MapSet.new(), %{}}, fn tissue, tuple_of_coord ->
       coordinates =
         for x <- 0..(tissue.x-1), y <- 0..(tissue.y-1) do
           {elem(tissue.start, 0) + x ,
                    elem(tissue.start, 1) + y}
         end

       Enum.reduce(coordinates, tuple_of_coord, fn coord, tuple_of_coord ->
           if MapSet.member?(elem(tuple_of_coord, 0), coord) do
             {elem(tuple_of_coord, 0),
              MapSet.put(elem(tuple_of_coord, 1), coord),
              Map.update(elem(tuple_of_coord, 2), coord, [tissue.id], fn x -> [ tissue.id | x] end)}
           else
             {MapSet.put(elem(tuple_of_coord, 0), coord),
             elem(tuple_of_coord, 1),
             Map.update(elem(tuple_of_coord, 2), coord, [tissue.id], fn x -> [ tissue.id | x] end)}
           end
         end)
     end)
 end
end
