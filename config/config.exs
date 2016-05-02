# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :trav, :config,
  twitter_callback_url: "http://localhost:4200/signin",
  allow_origin: "http://localhost:4200"

# Configures the endpoint
config :trav, Trav.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "duRn/yFNSGWMYURePZaM9A6FzSeyxVVdMgBc1lKLUvifuvOLqBrZxlzKrBDMqw+v",
  render_errors: [accepts: ~w(json)],
  pubsub: [name: Trav.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
