defmodule ExTokenManagerWeb.TokenControllerTest do
  use ExTokenManagerApiWeb.ConnCase

  alias ExTokenManagerApi.{Tokens, Repo}
  alias ExTokenManagerApi.Tokens.Token

  setup do
    Repo.delete_all(Token)
    Enum.each(1..100, fn _ -> Repo.insert!(%Token{}) end)
    :ok
  end

  test "POST /api/tokens/claim successfully claims a token", %{conn: conn} do
    user_id = Ecto.UUID.generate()
    conn = post(conn, ~p"/api/tokens/claim", %{"user_id" => user_id})

    assert %{
      "id" => _id,
      "status" =>  "ACTIVE",
      "inserted_at" => _inserted_at,
      "current_user_id" => ^user_id,
      "updated_at" => _updated_at
      } = json_response(conn, :created)

    assert length(Tokens.index(%{"status" => "ACTIVE"})) == 1
  end

end
