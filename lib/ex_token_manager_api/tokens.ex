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
end
