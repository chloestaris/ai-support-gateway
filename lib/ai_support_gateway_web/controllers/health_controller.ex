defmodule AiSupportGatewayWeb.HealthController do
  use AiSupportGatewayWeb, :controller

  def health(conn, _params) do
    json(conn, %{status: "ok"})
  end
end 