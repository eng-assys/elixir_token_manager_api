defmodule ExTokenManagerApiWeb.TokensJSON do
  def clear_active(%{
        results: %{released_tokens: {t_count, _}, released_histories: {h_count, _}}
      }) do
    %{
      message: "all tokens and histories cleared",
      tokens_affected: t_count,
      histories_affected: h_count
    }
  end

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

  def histories(%{token_histories: token_histories}) do
    %{
      items: for(token_history <- token_histories, do: history_item(token_history))
    }
  end

  defp history_item(token_history) do
    %{
      token_id: token_history.token_id,
      user_id: token_history.user_id,
      activated_at: token_history.activated_at,
      released_at: token_history.released_at
    }
  end

  def show(%{token: token}) do
    %{
      id: token.id,
      status: token.status,
      current_user_id: token.current_user_id,
      updated_at: token.updated_at,
      inserted_at: token.inserted_at
    }
  end
end
