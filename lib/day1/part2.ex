defmodule Aoc2018.Day1_2 do
  import Aoc2018
    def day1_2(args) do
      input_string(args)
      |> Enum.map(fn x -> String.to_integer(x) end)
      |> day1_2_recur
    end

    defp day1_2_recur(args) do
      day1_2_fin(args, args, [])
    end

    defp day1_2_fin(args, [], sum_list) do
      day1_2_fin(args, args, sum_list)
    end

    defp day1_2_fin(args, value_list, sum_list) do
      [hd | tl] = value_list
      [hd_to_add | _tail] = sum_list
      value = hd + hd_to_add
      if Enum.member?(sum_list, value) do
        value
      else
        day1_2_fin(args, tl, [value | sum_list])
      end
    end
end
