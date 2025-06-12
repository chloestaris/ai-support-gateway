defmodule AiSupportGatewayWeb.ConversationControllerTest do
  use AiSupportGatewayWeb.ConnCase
  import AiSupportGateway.Factory
  alias AiSupportGateway.Guardian

  setup %{conn: conn} do
    company_config = insert(:company_config)
    user = insert(:user)
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    authed_conn = put_req_header(conn, "authorization", "Bearer #{token}")
    {:ok, conn: conn, authed_conn: authed_conn, company_config: company_config, user: user}
  end

  describe "create conversation" do
    test "routes to correct AI model based on keywords", %{conn: conn, company_config: company_config} do
      params = %{
        "api_key" => company_config.api_key,
        "text" => "I need technical help with programming",
        "sentiment" => "neutral",
        "detected_language" => "en"
      }

      conn = post(conn, ~p"/api/conversations", params)
      assert %{
        "model" => "gpt-4",
        "response" => response,
        "conversation_id" => conversation_id,
        "metadata" => %{
          "max_tokens" => 2000,
          "temperature" => 0.7
        }
      } = json_response(conn, 200)

      assert is_binary(conversation_id)
      assert is_binary(response)
    end

    test "returns error with invalid API key", %{conn: conn} do
      params = %{
        "api_key" => "invalid_key",
        "text" => "Hello",
        "sentiment" => "neutral",
        "detected_language" => "en"
      }

      conn = post(conn, ~p"/api/conversations", params)
      assert json_response(conn, 401) == %{"error" => "invalid_api_key"}
    end
  end

  describe "list conversations" do
    test "requires authentication", %{conn: conn} do
      conn = get(conn, ~p"/api/conversations")
      assert json_response(conn, 401)
    end

    test "lists conversations when authenticated", %{authed_conn: conn} do
      conn = get(conn, ~p"/api/conversations")
      assert %{"conversations" => []} = json_response(conn, 200)
    end
  end

  describe "show conversation" do
    test "requires authentication", %{conn: conn} do
      conn = get(conn, ~p"/api/conversations/123")
      assert json_response(conn, 401)
    end

    test "shows conversation when authenticated", %{authed_conn: conn} do
      conn = get(conn, ~p"/api/conversations/123")
      assert %{"id" => "123", "status" => "retrieved"} = json_response(conn, 200)
    end
  end
end 