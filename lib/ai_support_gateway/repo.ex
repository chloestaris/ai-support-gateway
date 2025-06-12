defmodule AiSupportGateway.Repo do
  use Ecto.Repo,
    otp_app: :ai_support_gateway,
    adapter: Ecto.Adapters.Postgres
end 