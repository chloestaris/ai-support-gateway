defmodule AiSupportGateway.Companies.CompanyConfig do
  use Ecto.Schema
  import Ecto.Changeset

  schema "company_configs" do
    field :name, :string
    field :api_key, :string
    field :default_model, :string
    field :allowed_models, {:array, :string}
    field :max_tokens, :integer
    field :temperature, :float
    field :routing_rules, :map
    field :active, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company_config, attrs) do
    company_config
    |> cast(attrs, [:name, :api_key, :default_model, :allowed_models, :max_tokens, :temperature, :routing_rules, :active])
    |> validate_required([:name, :api_key, :default_model, :allowed_models])
    |> validate_number(:temperature, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 2.0)
    |> validate_number(:max_tokens, greater_than: 0)
    |> unique_constraint(:name)
    |> unique_constraint(:api_key)
  end
end 