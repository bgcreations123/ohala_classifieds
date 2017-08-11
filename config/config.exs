# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ohala_classifieds,
  ecto_repos: [OhalaClassifieds.Repo]

# Configures the endpoint
config :ohala_classifieds, OhalaClassifieds.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JJ8xFltC1rQ7AAmOiI1LyEygY6cHobbZp8CtD1jJLZ9gDx4OhsFoXlUjjOSMD6Lq",
  render_errors: [view: OhalaClassifieds.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OhalaClassifieds.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian Authentication
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "OhalaClassifieds",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "KBy+O5mmP9jkGErsx3rhP3+re4oEiN6kA3wbO2DKarKwumal1npCcYfLcasNSiyY",
  serializer: OhalaClassifieds.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
