defmodule Aoc2018.Day4_2 do
  import Aoc2018
  use Timex
  def spy_guard(input) do
    input
    |> input_string
    |> format_date
    |> minutes_asleep
  end

  defp minutes_asleep(list_of_guards_round) do
    {laziest_guard, minute_most_asleep, _total_times} =
      list_of_guards_round
      |> Enum.reduce(%{}, fn guard_round, map_of_guards ->
        Map.update(map_of_guards, guard_round.guard_id,
          %{guard_round.action => [guard_round.date]},
          fn value ->
            Map.update(value, guard_round.action, [guard_round.date],
            fn action_list ->
              action_list ++ [guard_round.date]
            end)
          end)
      end)
      |> Enum.map(fn {guard_id, actions} ->
        map_of_days =
          Enum.reduce(actions.shift, %{}, fn date, map_of_dates ->
            if date.hour == 23 do
              next_day = Timex.shift(date, days: 1)
              #|> Timex.set([hour: 0, minute: 0, second: 0])
              |> DateTime.to_date
              Map.put_new(map_of_dates, next_day, %{})
            else
              Map.put_new(map_of_dates, date|> DateTime.to_date , %{})
            end
          end)
        map_of_days =
          if Map.has_key?(actions, :asleep) do
            map_of_days = Enum.reduce(actions.asleep, map_of_days, fn asleep_time, map_of_days ->
              Map.update(map_of_days, asleep_time |> DateTime.to_date, [asleep_time.minute], fn minutes -> Map.update(minutes, :asleep_minutes, [asleep_time.minute], fn val -> val ++ [asleep_time.minute] end)  end) # minutes ++ [asleep_time.minute]
            end)
            Enum.reduce(actions.awake, map_of_days, fn awake_time, map_of_days ->
              Map.update(map_of_days, awake_time |> DateTime.to_date, [awake_time.minute], fn minutes_list -> Map.update(minutes_list, :asleep_minutes, [], fn val ->
                asleep_minute = Enum.max_by(val,  &(if((&1 - awake_time.minute)<=0) do (&1-awake_time.minute) else -100 end)) # get the closest value to the awake minute
                Enum.to_list(asleep_minute+1..(awake_time.minute-1)) ++ val |> Enum.sort
              end)
            end)
            end)
          end

      {minute_most_asleep, number_of_times} =
        if map_of_days == nil do
          {0,0}
        else
          map_of_days
          |> Map.to_list
          |> Enum.map(fn {_day, map} -> Map.values(map) |> List.flatten end)
          |> Enum.reduce(%{}, fn list_of_minutes, map ->
                Enum.reduce(list_of_minutes, map, fn minute, map ->
                  Map.update(map, minute, 1, fn val -> val + 1 end)
                end)
            end)
          |> Map.to_list
          |> Enum.max_by(fn val -> elem(val, 1) end)
        end
      {guard_id, minute_most_asleep, number_of_times}
      end)
      |> Enum.max_by(fn val -> elem(val, 2) end)


    {laziest_guard, minute_most_asleep, (laziest_guard*minute_most_asleep)}

  end

  defp format_date(input) do
    Enum.map(input, fn string ->
        [date, action] = String.split(string, ["[","]"], trim: true)
        [date, time] = String.split(date, " ", trim: true)
        {:ok, date, 0} =
          date<>"T"<>time<>":00Z"
          |> DateTime.from_iso8601

        cond do
          String.contains?(action, "asleep") ->
            %{date: date, action: :asleep}
          String.contains?(action, "wakes") ->
            %{date: date, action: :awake}
          String.contains?(action, "shift") ->
            guard_id = String.split(action, " ", trim: true)
            |> Enum.at(1)
            |> String.slice(1..-1)
            |> String.to_integer
            %{date: date, action: :shift, guard_id: guard_id}
        end
      end)
      |> Enum.sort_by(fn record -> record.date |> DateTime.to_unix end)
      |> Enum.map_reduce(0, fn guard, prev_id ->
          if Map.has_key?(guard, :guard_id) do
            {guard, guard.guard_id}
          else
            {Map.put_new(guard, :guard_id, prev_id), prev_id}
          end
        end)
      |> elem(0)
  end
end
