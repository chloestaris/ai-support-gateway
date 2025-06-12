defmodule Mix.Tasks.CreateUser do
  use Mix.Task
  alias AiSupportGateway.{Repo, Accounts}

  @shortdoc "Creates a new user"
  def run([email, password]) do
    Mix.Task.run("app.start")
    
    case Accounts.create_user(%{email: email, password: password}) do
      {:ok, user} ->
        Mix.shell().info("User created successfully: #{user.email}")
      {:error, changeset} ->
        Mix.shell().error("Failed to create user: #{inspect(changeset.errors)}")
    end
  end

  def run(_) do
    Mix.shell().error("Usage: mix create_user EMAIL PASSWORD")
  end
end 