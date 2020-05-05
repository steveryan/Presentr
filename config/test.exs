use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :presentr, PresentrWeb.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

config :phoenix_integration,
  endpoint: PresentrWeb.Endpoint
