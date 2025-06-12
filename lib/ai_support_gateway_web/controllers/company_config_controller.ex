defmodule AiSupportGatewayWeb.CompanyConfigController do
  use AiSupportGatewayWeb, :controller

  alias AiSupportGateway.Companies
  alias AiSupportGateway.Companies.CompanyConfig

  action_fallback AiSupportGatewayWeb.FallbackController

  def index(conn, _params) do
    company_configs = Companies.list_company_configs()
    render(conn, :index, company_configs: company_configs)
  end

  def create(conn, %{"company_config" => company_config_params}) do
    with {:ok, %CompanyConfig{} = company_config} <- Companies.create_company_config(company_config_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/company_configs/#{company_config}")
      |> render(:show, company_config: company_config)
    end
  end

  def show(conn, %{"id" => id}) do
    company_config = Companies.get_company_config!(id)
    render(conn, :show, company_config: company_config)
  end

  def update(conn, %{"id" => id, "company_config" => company_config_params}) do
    company_config = Companies.get_company_config!(id)

    with {:ok, %CompanyConfig{} = company_config} <- Companies.update_company_config(company_config, company_config_params) do
      render(conn, :show, company_config: company_config)
    end
  end

  def delete(conn, %{"id" => id}) do
    company_config = Companies.get_company_config!(id)

    with {:ok, %CompanyConfig{}} <- Companies.delete_company_config(company_config) do
      send_resp(conn, :no_content, "")
    end
  end
end

defmodule AiSupportGatewayWeb.CompanyConfigJSON do
  alias AiSupportGateway.Companies.CompanyConfig

  @doc """
  Renders a list of company_configs.
  """
  def index(%{company_configs: company_configs}) do
    %{data: for(company_config <- company_configs, do: data(company_config))}
  end

  @doc """
  Renders a single company_config.
  """
  def show(%{company_config: company_config}) do
    %{data: data(company_config)}
  end

  defp data(%CompanyConfig{} = company_config) do
    %{
      id: company_config.id,
      name: company_config.name,
      api_key: company_config.api_key,
      default_model: company_config.default_model,
      allowed_models: company_config.allowed_models,
      max_tokens: company_config.max_tokens,
      temperature: company_config.temperature,
      routing_rules: company_config.routing_rules,
      active: company_config.active
    }
  end
end 