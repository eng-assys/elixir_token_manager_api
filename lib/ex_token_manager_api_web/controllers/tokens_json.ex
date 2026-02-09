defmodule ExTokenManagerApiWeb.TokensJSON do
  def index(%{tokens: tokens}) do
    %{items: for(token <- tokens, do: items(token))}
  end

  defp items(token) do
    %{
      id: token.id,
      status: token.status,
      current_user_id: token.current_user_id,
      updated_at: token.updated_at,
      inserted_at: token.inserted_at
    }
  end
end
