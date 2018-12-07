defmodule Aoc2018.Day3_1 do
  import Aoc2018
  def overlapping_tiles(input) do
    input
    |> input_string
    |> format_string_to_tissue
    |> cut_tissue
    |> elem(1)
    |> MapSet.size
  end

   defp cut_tissue(list_of_tissues) do
    list_of_tissues
    |> Enum.reduce({MapSet.new(), MapSet.new()}, fn tissue, tuple_of_coord ->
        coordinates =
          for x <- 0..(tissue.x-1), y <- 0..(tissue.y-1) do
            {elem(tissue.start, 0) + x ,
                     elem(tissue.start, 1) + y}
          end
        Enum.reduce(coordinates, tuple_of_coord, fn coord, tuple_of_coord ->
            if MapSet.member?(elem(tuple_of_coord, 0), coord) do
              {elem(tuple_of_coord, 0), MapSet.put(elem(tuple_of_coord, 1), coord)}

            else
              {MapSet.put(elem(tuple_of_coord, 0), coord), elem(tuple_of_coord, 1)}
            end
          end)
      end)
  end

  def format_string_to_tissue(list_of_strings) do
    list_of_strings
    |> Enum.map(fn string ->
      coordinates =
        String.split(string, [" ", ":", "@", "#"], trim: true)
      coord = Enum.map(String.split(Enum.at(coordinates, 1), ","), fn co -> String.to_integer(co) end)

      size = String.split(Enum.at(coordinates, 2), "x")

      %{start: {List.first(coord), List.last(coord)},
       x: List.first(size) |> String.to_integer,
       y: List.last(size) |> String.to_integer,
       id: Enum.at(coordinates,0) |> String.to_integer}
      end)
  end


end
