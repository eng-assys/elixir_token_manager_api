defmodule ExTokenManagerApi.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :status, :string, default: "AVAILABLE", null: false
      add :current_user_id, :binary_id
      timestamps()
    end

    create table(:token_usage_histories) do
      add :token_id, references(:tokens, type: :binary_id, on_delete: :delete_all)
      add :user_id, :binary_id, null: false
      add :activated_at, :utc_datetime
      add :released_at, :utc_datetime
    end

    create index(:tokens, [:status])
    create index(:token_usage_histories, [:token_id])
  end
end
