defmodule AiSupportGateway.Accounts do
  import Ecto.Query
  alias AiSupportGateway.Repo
  alias AiSupportGateway.Accounts.User

  def get_user(id) do
    Repo.get(User, id)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def authenticate_user(email, password) do
    user = get_user_by_email(email)

    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        Bcrypt.no_user_verify()
        {:error, :not_found}
    end
  end
end 