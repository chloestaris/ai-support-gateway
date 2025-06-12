defmodule AiSupportGatewayWeb.AuthControllerTest do
  use AiSupportGatewayWeb.ConnCase
  import AiSupportGateway.Factory

  describe "authorize" do
    test "redirects with token for valid implicit flow request", %{conn: conn} do
      user = insert(:user)
      
      params = %{
        "client_id" => "test_client",
        "redirect_uri" => "http://localhost:3000/callback",
        "response_type" => "token",
        "username" => user.email,
        "password" => "password123"
      }

      conn = get(conn, ~p"/api/oauth/authorize", params)
      assert response = response(conn, 302)
      assert [location] = get_resp_header(conn, "location")
      assert String.starts_with?(location, "http://localhost:3000/callback#access_token=")
      assert String.contains?(location, "token_type=Bearer")
      assert String.contains?(location, "expires_in=86400")
    end

    test "redirects with error for invalid credentials", %{conn: conn} do
      params = %{
        "client_id" => "test_client",
        "redirect_uri" => "http://localhost:3000/callback",
        "response_type" => "token",
        "username" => "invalid@example.com",
        "password" => "wrong"
      }

      conn = get(conn, ~p"/api/oauth/authorize", params)
      assert response = response(conn, 302)
      assert [location] = get_resp_header(conn, "location")
      assert location == "http://localhost:3000/callback#error=invalid_grant"
    end

    test "returns error for invalid request", %{conn: conn} do
      conn = get(conn, ~p"/api/oauth/authorize", %{})
      assert json_response(conn, 400) == %{"error" => "invalid_request"}
    end
  end

  describe "token" do
    test "returns token for valid password grant", %{conn: conn} do
      user = insert(:user)
      
      params = %{
        "grant_type" => "password",
        "username" => user.email,
        "password" => "password123"
      }

      conn = post(conn, ~p"/api/oauth/token", params)
      assert %{
        "access_token" => token,
        "token_type" => "Bearer",
        "expires_in" => 86400
      } = json_response(conn, 200)

      assert is_binary(token)
    end

    test "returns error for invalid credentials", %{conn: conn} do
      params = %{
        "grant_type" => "password",
        "username" => "invalid@example.com",
        "password" => "wrong"
      }

      conn = post(conn, ~p"/api/oauth/token", params)
      assert json_response(conn, 401) == %{"error" => "invalid_grant"}
    end

    test "returns error for unsupported grant type", %{conn: conn} do
      params = %{
        "grant_type" => "client_credentials"
      }

      conn = post(conn, ~p"/api/oauth/token", params)
      assert json_response(conn, 400) == %{"error" => "unsupported_grant_type"}
    end
  end
end 