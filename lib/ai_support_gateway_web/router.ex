defmodule AiSupportGatewayWeb.Router do
  use AiSupportGatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug AiSupportGatewayWeb.AuthPlug
  end

  scope "/api", AiSupportGatewayWeb do
    pipe_through :api

    get "/health", HealthController, :health
    post "/conversations", ConversationController, :create
  end

  scope "/api", AiSupportGatewayWeb do
    pipe_through :api_auth

    get "/conversations", ConversationController, :index
    resources "/company_configs", CompanyConfigController, except: [:new, :edit]
  end

  # Enable OpenApiSpex for swagger documentation
  scope "/" do
    pipe_through :api

    get "/api/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/api/swaggerui" do
    pipe_through :api

    get "/", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:ai_support_gateway, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: AiSupportGatewayWeb.Telemetry
    end
  end
end 