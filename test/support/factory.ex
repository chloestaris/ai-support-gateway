defmodule AiSupportGateway.Factory do
  use ExMachina.Ecto, repo: AiSupportGateway.Repo

  def company_config_factory do
    %AiSupportGateway.Companies.CompanyConfig{
      name: sequence(:name, &"Company #{&1}"),
      api_key: sequence(:api_key, &"api_key_#{&1}"),
      default_model: "gpt-4",
      allowed_models: ["gpt-4", "gpt-3.5-turbo", "claude-3"],
      max_tokens: 2000,
      temperature: 0.7,
      routing_rules: [
        %{
          "condition" => %{
            "contains_keywords" => ["technical", "code", "programming"]
          },
          "model" => "gpt-4"
        }
      ],
      active: true
    }
  end

  def user_factory do
    %AiSupportGateway.Accounts.User{
      email: sequence(:email, &"user#{&1}@example.com"),
      password_hash: Bcrypt.hash_pwd_salt("password123")
    }
  end
end 