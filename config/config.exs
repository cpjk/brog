# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

{:ok, guardian_secret} = File.read("guardian_secret")

config :blog, ecto_repos: [Blog.Repo]

# Configures the endpoint
config :blog, Blog.Endpoint,
  root: Path.dirname(__DIR__),
  url: [host: "localhost"],
  secret_key_base: "Y1UsNEa127/mT27tigE2YPO/6BPAwziXo+3btejyhp6ijlLKzxlYb2PLhGIysRO/",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Blog.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :joken, config_module: Guardian.JWT

config :guardian, Guardian,
  issuer: "Blog",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: guardian_secret,
  serializer: Blog.GuardianSerializer

config :canary,
  repo: Blog.Repo,
  current_user: :guardian_default_resource,
  unauthorized_handler: {Blog.ControllerHelpers, :handle_unauthorized},
  not_found_handler: {Blog.ControllerHelpers, :handle_not_found}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
