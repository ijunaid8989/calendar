defmodule Kalendar.Repo do
  use Ecto.Repo,
    otp_app: :kalendar,
    adapter: Ecto.Adapters.Postgres
end
