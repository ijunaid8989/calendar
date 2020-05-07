defmodule KalendarWeb.PageLive do
  use KalendarWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, content: %{name: "Junaid"})}
  end
end
