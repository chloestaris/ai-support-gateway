defmodule AiSupportGateway.Release do
  @app :ai_support_gateway

  def migrate do
    load_app()
    start_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    start_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def create_user(email, password) do
    load_app()
    
    {:ok, _} = Application.ensure_all_started(:bcrypt_elixir)
    
    Ecto.Migrator.with_repo(AiSupportGateway.Repo, fn repo ->
      %AiSupportGateway.Accounts.User{}
      |> AiSupportGateway.Accounts.User.changeset(%{email: email, password: password})
      |> repo.insert()
      |> case do
        {:ok, user} -> IO.puts("User created successfully: #{user.email}")
        {:error, changeset} -> IO.puts("Failed to create user: #{inspect(changeset.errors)}")
      end
    end)
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  defp start_app do
    Application.ensure_all_started(@app)
  end
end 