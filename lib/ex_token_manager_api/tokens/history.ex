defmodule ExTokenManagerApi.Tokens.History do
  use Ecto.Schema

  alias ExTokenManagerApi.Tokens.Token

  schema "token_usage_histories" do
    field :user_id, :binary_id
    field :activated_at, :utc_datetime
    field :released_at, :utc_datetime

    belongs_to :token, Token
  end
end
