defmodule ExTokenManagerApi.TokenTest do
  use ExTokenManagerApi.DataCase

  alias ExTokenManagerApi.Tokens
  alias ExTokenManagerApi.Repo
  alias ExTokenManagerApi.Tokens.Token

  test "release_token/1 turn token available after release" do
    token = Repo.insert!(%Token{status: "ACTIVE", current_user_id: Ecto.UUID.generate()})

    updated_token = Tokens.release_token(token)

    assert updated_token.status == "AVAILABLE"
    assert is_nil(updated_token.current_user_id)
  end

  test "automatic expiration via message" do
    token = Repo.insert!(%Token{status: "ACTIVE", current_user_id: Ecto.UUID.generate()})

    Tokens.release_token(token)

    assert Tokens.show!(token.id).status == "AVAILABLE"
  end
end
