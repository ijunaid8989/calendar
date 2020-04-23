# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kalendar,
  ecto_repos: [Kalendar.Repo]

# Configures the endpoint
config :kalendar, KalendarWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mEZ7V6edu4kYiSmkpl1f3KQe323NZfI/pgxOYbl5Yl7W9ofqIEk4o2oQphZrZEy2",
  render_errors: [view: KalendarWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Kalendar.PubSub,
  live_view: [signing_salt: "04SvZaam"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
