defmodule ExTokenManagerApi.Tokens do
  import Ecto.Query

  alias ExTokenManagerApi.Repo
  alias ExTokenManagerApi.Tokens.Token
  alias ExTokenManagerApi.Tokens.TokenUsageHistory

  def index(params \\ %{}) do
    Token
    |> filter_by_status(params["status"])
    |> Repo.all()
  end

  defp filter_by_status(query, status) when status in [nil, ""], do: query

  defp filter_by_status(query, status) do
    from(t in query, where: t.status == ^status)
  end

  def show!(id), do: Repo.get!(Token, id)

  def show_histories!(id) do
    from(h in TokenUsageHistory,
      where: h.token_id == ^id,
      order_by: [desc: h.activated_at]
    )
    |> Repo.all()
  end

  def claim(user_id) do
    Repo.transaction(fn ->
      active_count = Repo.one(from t in Token, where: t.status == "ACTIVE", select: count(t.id))

      if active_count >= 100 do
        oldest = Repo.one(from t in Token, where: t.status == "ACTIVE", order_by: [asc: :updated_at], limit: 1)
        release_token(oldest)
      end

      token = Repo.one(from t in Token, where: t.status == "AVAILABLE", limit: 1)

      if token do
        Repo.insert!(%TokenUsageHistory{token_id: token.id, user_id: user_id, activated_at:  DateTime.utc_now() |> DateTime.truncate(:second)})

        token
        |> Token.changeset(%{status: "ACTIVE", current_user_id: user_id})
        |> Repo.update!()
        |> schedule_release()
      else
        Repo.rollback(:no_tokens_available)
      end
    end)
  end

  def release_token(token) do
    from(h in TokenUsageHistory, where: h.token_id == ^token.id and is_nil(h.released_at))
    |> Repo.update_all(set: [released_at:  DateTime.utc_now() |> DateTime.truncate(:second)])

    token
    |> Token.changeset(%{status: "AVAILABLE", current_user_id: nil})
    |> Repo.update!()
  end

  defp schedule_release(token) do
    Process.send_after(ExTokenManagerApi.Worker, {:release, token.id}, 2 * 60 * 1000)
    token
  end
end
