defmodule KalendarWeb.PageLive do
  use KalendarWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :kalendar, kalendar_state())}
  end

  def kalendar_state(date \\ Calendar.DateTime.now_utc) do
    %{day: day, month: month, year: year} = date
    days_in_next_month = if month + 1 > 12, do: Timex.days_in_month(year, 1), else: Timex.days_in_month(year, (month + 1))
    days_in_prev_month = if month - 1 < 1, do: Timex.days_in_month(year, 1), else: Timex.days_in_month(year, (month - 1))
    month_next = if month + 1 > 12, do: 12, else: month
    month_prev = if month - 1 < 1, do: 1, else: month
    %{
      month: Timex.month_name(month),
      year: year,
      day: day,
      month_number_next: month_next,
      month_number_prev: month_prev,
      days_in_next_month: days_in_next_month,
      days_in_prev_month: days_in_prev_month,
      days_in_current_month: Timex.days_in_month(year, month),
      full_calendar: get_full_calendar(date)
    } |> IO.inspect
  end

  def get_full_calendar(date) do
    %{month: month, year: year} = date
    days_in_month = Timex.days_in_month(year, month)
    month_start = Timex.beginning_of_month(date)
    month_end = Timex.end_of_month(date)
    days_sequence = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    month_start_day = Calendar.Strftime.strftime!(month_start, "%A")
    month_end_day = Calendar.Strftime.strftime!(month_end, "%A")
    current_day = Calendar.Strftime.strftime!(date, "%d")
    current_month = Calendar.Strftime.strftime!(date, "%B")
    how_far_is_sunday = Enum.find_index(days_sequence, fn day -> day == month_start_day end)
    how_far_is_saturday = Enum.find_index(days_sequence, fn day -> day == month_end_day end)

    starting_dates = discover_starting_dates(how_far_is_sunday, month_start)
    ending_dates = discover_ending_dates(how_far_is_saturday, month_end)
    month_dates = discover_month_dates(month_start, days_in_month)

    adds_up = Enum.count(starting_dates) + Enum.count(ending_dates) + Enum.count(month_dates) |> need_adds_up(ending_dates)

    starting_dates ++ month_dates ++ ending_dates ++ adds_up
    |> format_calendar(current_month)
  end

  defp need_adds_up(42, _ending_dates), do: []
  defp need_adds_up(count, ending_dates) do
    start_with = ending_dates |> List.last
    for i <- 1..(42 - count) do
      Calendar.DateTime.add!(start_with, 86400 * i)
    end
  end

  defp format_calendar(dates, current_month) do
   today_month = Calendar.Strftime.strftime!(Calendar.DateTime.now_utc, "%B")
   today_day = Calendar.Strftime.strftime!(Calendar.DateTime.now_utc, "%d")
   Enum.map(dates, fn date ->
      IO.inspect date
      %{
        day: Calendar.Strftime.strftime!(date, "%d"),
        class: (if current_month == Calendar.Strftime.strftime!(date, "%B"), do: "in-month", else: "text-muted"),
        current: (if today_day == Calendar.Strftime.strftime!(date, "%d") && today_month == Calendar.Strftime.strftime!(date, "%B"), do: "current", else: "")
      }
    end)
  end

  defp discover_starting_dates(0, _month_start), do: []
  defp discover_starting_dates(1, month_start), do: [month_start |> Calendar.DateTime.subtract!(86400)]
  defp discover_starting_dates(index, month_start) do
    for i <- 1..index do
      Calendar.DateTime.subtract!(month_start, 86400 * i)
    end |> Enum.sort(&(&1 < &2))
  end

  defp discover_ending_dates(7, _month_end), do: []
  defp discover_ending_dates(6, month_end), do: [month_end |> Calendar.DateTime.add!(86400)]
  defp discover_ending_dates(index, month_end) do
    for i <- 1..(7 - index - 1) do
      Calendar.DateTime.add!(month_end, 86400 * i)
    end
  end

  defp discover_month_dates(month_start, days_in_month) do
    Stream.iterate(month_start, &(Calendar.DateTime.add!(&1, 86400)))
    |> Enum.take(days_in_month)
  end
end
