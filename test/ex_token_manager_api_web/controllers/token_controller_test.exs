defmodule ExTokenManagerWeb.TokenControllerTest do
  import Ecto.Query

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


  test "POST /tokens/claim when exceed 100 activated tokens should get older one", %{conn: conn} do
    user_id = Ecto.UUID.generate()
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    {_count, _} = Repo.update_all(Token, set: [
      status: "ACTIVE",
      current_user_id: user_id,
      updated_at: now
    ])

    new_user = Ecto.UUID.generate()
    conn = post(conn, ~p"/api/tokens/claim", %{"user_id" => new_user})

    assert json_response(conn, :created)

    active_count = Repo.one(from t in Token, where: t.status == "ACTIVE", select: count(t.id))
    assert active_count == 100
  end
end
