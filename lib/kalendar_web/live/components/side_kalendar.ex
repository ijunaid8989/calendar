defmodule SideKalendar do
  use Phoenix.LiveComponent
  import String

  def handle_event("next_month", %{"year" => year, "month" => month, "day" => day} = params, socket) do
    state =
      Calendar.DateTime.from_erl!({{to_integer(year), to_integer(month), to_integer(day)}, {0, 0, 0}}, "UTC", 123456)
      |> Calendar.DateTime.add!(86400 * Timex.days_in_month(to_integer(year), (to_integer(month) + 1)))
      |> KalendarWeb.PageLive.kalendar_state
    {:noreply, assign(socket, kalendar: state)}
  end
end