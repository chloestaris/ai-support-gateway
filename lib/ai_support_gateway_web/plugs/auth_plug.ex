defmodule AiSupportGatewayWeb.AuthPlug do
  import Plug.Conn
  alias AiSupportGateway.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Basic " <> encoded_credentials] <- get_req_header(conn, "authorization"),
         {:ok, credentials} <- Base.decode64(encoded_credentials),
         [email, password] <- String.split(credentials, ":", parts: 2),
         {:ok, user} <- Accounts.authenticate_user(email, password) do
      assign(conn, :current_user, user)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "Invalid credentials"})
        |> halt()
    end
  end
end 