defmodule Aoc2018.Day1_1 do
  import Aoc2018
  def day1_1(args) do
    input_string(args)
    |> Enum.reduce(0, fn x, acc -> String.to_integer(x) + acc end)
  end
end
