defmodule AiSupportGatewayWeb.CompanyConfigControllerTest do
  use AiSupportGatewayWeb.ConnCase
  import AiSupportGateway.Factory

  setup %{conn: conn} do
    user = insert(:user, email: "test@example.com", password: "password123")
    credentials = Base.encode64("test@example.com:password123")
    conn = put_req_header(conn, "authorization", "Basic #{credentials}")
    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all company_configs", %{conn: conn} do
      company_config = insert(:company_config)
      conn = get(conn, ~p"/api/company_configs")
      assert %{
        "data" => [
          %{
            "id" => id,
            "name" => name,
            "api_key" => api_key,
            "default_model" => "gpt-4"
          } | _
        ]
      } = json_response(conn, 200)
      assert id == company_config.id
      assert name == company_config.name
      assert api_key == company_config.api_key
    end
  end

  describe "create company_config" do
    test "renders company_config when data is valid", %{conn: conn} do
      params = %{
        company_config: %{
          name: "Test Company",
          api_key: "test_api_key",
          default_model: "gpt-4",
          allowed_models: ["gpt-4", "gpt-3.5-turbo"],
          max_tokens: 2000,
          temperature: 0.7,
          routing_rules: %{
            rules: [
              %{
                condition: %{
                  contains_keywords: ["technical"]
                },
                model: "gpt-4"
              }
            ]
          }
        }
      }

      conn = post(conn, ~p"/api/company_configs", params)
      assert %{"data" => data} = json_response(conn, 201)
      assert data["name"] == "Test Company"
      assert data["api_key"] == "test_api_key"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = %{company_config: %{name: nil}}
      conn = post(conn, ~p"/api/company_configs", params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update company_config" do
    setup [:create_company_config]

    test "renders company_config when data is valid", %{conn: conn, company_config: company_config} do
      params = %{
        company_config: %{
          name: "Updated Company"
        }
      }

      conn = put(conn, ~p"/api/company_configs/#{company_config}", params)
      assert %{"data" => data} = json_response(conn, 200)
      assert data["name"] == "Updated Company"
    end

    test "renders errors when data is invalid", %{conn: conn, company_config: company_config} do
      params = %{company_config: %{name: nil}}
      conn = put(conn, ~p"/api/company_configs/#{company_config}", params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete company_config" do
    setup [:create_company_config]

    test "deletes chosen company_config", %{conn: conn, company_config: company_config} do
      conn = delete(conn, ~p"/api/company_configs/#{company_config}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/company_configs/#{company_config}")
      end
    end
  end

  defp create_company_config(_) do
    company_config = insert(:company_config)
    %{company_config: company_config}
  end
end 