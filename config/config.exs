import Config

config :ai_support_gateway,
  ecto_repos: [AiSupportGateway.Repo]

# Configures the endpoint
config :ai_support_gateway, AiSupportGatewayWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: AiSupportGatewayWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AiSupportGateway.PubSub,
  live_view: [signing_salt: "YOUR_LIVE_VIEW_SIGNING_SALT"]

# Configure esbuild
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs" 