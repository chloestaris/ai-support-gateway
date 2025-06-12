defmodule AiSupportGateway.Repo.Migrations.CreateCompanyConfigs do
  use Ecto.Migration

  def change do
    create table(:company_configs) do
      add :name, :string, null: false
      add :api_key, :string, null: false
      add :default_model, :string, null: false
      add :allowed_models, {:array, :string}, null: false
      add :max_tokens, :integer
      add :temperature, :float
      add :routing_rules, :map
      add :active, :boolean, default: true, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:company_configs, [:name])
    create unique_index(:company_configs, [:api_key])
  end
end 