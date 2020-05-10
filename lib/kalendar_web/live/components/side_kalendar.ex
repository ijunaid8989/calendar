defmodule SideKalendar do
  use Phoenix.LiveComponent
  import String

  def handle_event("next_month", %{"year" => year, "month" => month, "day" => day, "days_in_next_month" => days_in_next_month} = params, socket) do
    state =
      Calendar.DateTime.from_erl!({{to_integer(year), to_integer(month), to_integer(day)}, {0, 0, 0}}, "UTC", 123456)
      |> Calendar.DateTime.add!(86400 * to_integer(days_in_next_month))
      |> KalendarWeb.PageLive.kalendar_state
    {:noreply, assign(socket, kalendar: state)}
  end

  def handle_event("prev_month", %{"year" => year, "month" => month, "day" => day, "days_in_prev_month" => days_in_prev_month} = params, socket) do
    state =
      Calendar.DateTime.from_erl!({{to_integer(year), to_integer(month), to_integer(day)}, {0, 0, 0}}, "UTC", 123456)
      |> Calendar.DateTime.subtract!(86400 * to_integer(days_in_prev_month))
      |> KalendarWeb.PageLive.kalendar_state
    {:noreply, assign(socket, kalendar: state)}
  end
end


