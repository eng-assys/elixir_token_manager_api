defmodule ExTokenManagerApi.Tokens.Token do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExTokenManagerApi.Tokens.TokenUsageHistory

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "tokens" do
    field :status, :string, default: "AVAILABLE"
    field :current_user_id, :binary_id

    has_many :history, TokenUsageHistory
    timestamps()
  end

  def changeset(token, attrs) do
    token
    |> cast(attrs, [:status, :current_user_id])
    |> validate_inclusion(:status, ["AVAILABLE", "ACTIVE"])
  end
end
