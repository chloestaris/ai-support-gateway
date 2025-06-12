defmodule AiSupportGateway.Companies do
  import Ecto.Query, warn: false
  alias AiSupportGateway.Repo
  alias AiSupportGateway.Companies.CompanyConfig

  def list_company_configs do
    Repo.all(CompanyConfig)
  end

  def get_company_config!(id), do: Repo.get!(CompanyConfig, id)

  def get_company_config_by_api_key(api_key) do
    Repo.get_by(CompanyConfig, api_key: api_key)
  end

  def create_company_config(attrs \\ %{}) do
    %CompanyConfig{}
    |> CompanyConfig.changeset(attrs)
    |> Repo.insert()
  end

  def update_company_config(%CompanyConfig{} = company_config, attrs) do
    company_config
    |> CompanyConfig.changeset(attrs)
    |> Repo.update()
  end

  def delete_company_config(%CompanyConfig{} = company_config) do
    Repo.delete(company_config)
  end

  def change_company_config(%CompanyConfig{} = company_config, attrs \\ %{}) do
    CompanyConfig.changeset(company_config, attrs)
  end

  def get_model_for_conversation(company_config, conversation) do
    case evaluate_routing_rules(company_config.routing_rules, conversation) do
      nil -> company_config.default_model
      model -> model
    end
  end

  defp evaluate_routing_rules(nil, _conversation), do: nil
  defp evaluate_routing_rules(%{"rules" => rules}, conversation) when is_list(rules) do
    Enum.find_value(rules, fn rule ->
      case evaluate_rule(rule, conversation) do
        true -> rule["model"]
        false -> nil
      end
    end)
  end
  defp evaluate_routing_rules(_, _conversation), do: nil

  defp evaluate_rule(%{"condition" => condition, "model" => _model} = rule, conversation) do
    case condition do
      %{"contains_keywords" => keywords} ->
        text = conversation.text || ""
        Enum.any?(keywords, &String.contains?(String.downcase(text), String.downcase(&1)))
      
      %{"sentiment" => sentiment} ->
        conversation.sentiment == sentiment
      
      %{"language" => language} ->
        conversation.detected_language == language
      
      _ -> false
    end
  end
end 