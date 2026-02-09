defmodule ExTokenManagerApi.Tokens do
  import Ecto.Query

  alias ExTokenManagerApi.Repo
  alias ExTokenManagerApi.Tokens.Token

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
end
