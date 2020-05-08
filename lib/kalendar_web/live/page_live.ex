defmodule KalendarWeb.PageLive do
  use KalendarWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :kalendar, kalendar_state())}
  end

  def kalendar_state(date \\ Calendar.DateTime.now_utc) do
    %{day: day, month: month, year: year} = date
    %{
      month: Timex.month_name(month),
      year: year,
      day: day,
      month_number: month,
      days_in_month: Timex.days_in_month(year, month),
      days_in_next_month: Timex.days_in_month(year, (month + 1))
    } |> IO.inspect
  end
end
