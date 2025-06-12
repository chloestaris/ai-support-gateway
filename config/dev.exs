import Config

# Configure your database
config :ai_support_gateway, AiSupportGateway.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ai_support_gateway_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
config :ai_support_gateway, AiSupportGatewayWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "YOUR_DEV_SECRET_KEY_BASE",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

# Enable dev routes for dashboard and mailbox
config :ai_support_gateway, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Include CORS configuration for development
config :ai_support_gateway, AiSupportGatewayWeb.Endpoint,
  cors_plug_options: [
    origin: ["http://localhost:3000"],
    max_age: 86400,
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    headers: ["Authorization", "Content-Type", "Accept", "Origin", "User-Agent"]
  ] 