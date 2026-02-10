defmodule ExTokenManagerApiWeb.TokensController do
  use ExTokenManagerApiWeb, :controller
  use PhoenixSwagger

  alias ExTokenManagerApi.Tokens

  def swagger_definitions do
    %{
      ClaimRequest: swagger_schema do
        title "Claim Request"
        properties do
          user_id :string, "Claimant User's UUID", required: true
        end
      end,
      ClearResponse: swagger_schema do
        title "Clear Response"
        properties do
          tokens_affected :integer, "Reset Tokens amount"
          history_closed :integer, "Closed History records amount"
        end
      end,
      Token:
        swagger_schema do
          title("Token")
          description("A token to access an resource")

          properties do
            id(:string, "Token's UUID", format: :uuid)
            status(:string, "Status (ACTIVE/AVAILABLE)", example: "ACTIVE")
            current_user_id(:string, "Current User ID", format: :uuid)
            inserted_at(:string, "Insertion timestamp", format: "date-time")
            updated_at(:string, "Last update timestamp", format: "date-time")
          end
        end,
      TokenList: swagger_schema do
        title "Tokens List"
        type :array
        items Schema.ref(:Token)
      end,
      TokenUsageHistory: swagger_schema do
        title "Token Usage History"
        properties do
          id(:integer, "History record's id", format: :id, example: 1)
          token_id(:string, "Associated Token's UUID", format: :uuid)
          activated_at(:string, "Activation timestamp", format: "date-time")
          released_at(:string, "Release timestamp", format: "date-time")
          user_id(:string, "User ID who claimed the token", format: :uuid)
        end
      end,
      TokenUsageHistoryList: swagger_schema do
        title "Tokens Usage History List"
        type :array
        items Schema.ref(:TokenUsageHistory)
      end,
    }
  end

  def claim(conn, %{"user_id" => user_id}) do
    with {:ok, token} <- Tokens.claim(user_id) do
      conn
      |> put_status(:created)
      |> render(:show, token: token)
    end
  end

  def clear_active(conn, _params) do
    with {:ok, results} <- Tokens.clear_active_and_release_histories() do
      conn
      |> put_status(:ok)
      |> render(:clear_active, results: results)
    end
  end

  def index(conn, params) do
    with {:ok, tokens} <- {:ok, Tokens.index(params)} do
      conn
      |> put_status(:ok)
      |> render(:index, tokens: tokens)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, token} <- {:ok, Tokens.show!(id)} do
      conn
      |> put_status(:ok)
      |> render(:show, token: token)
    end
  end

  swagger_path :history do
    get("/api/tokens/{id}/history")
    summary("List the history of a token")

    parameters do
      id(:path, :string, "Token's UUID", required: true)
    end

    response(200, "OK", Schema.ref(:TokenUsageHistoryList))
  end

  def history(conn, %{"id" => id}) do
    with {:ok, token_histories} <- {:ok, Tokens.show_histories!(id)} do
      conn
      |> put_status(:ok)
      |> render(:histories, token_histories: token_histories)
    end
  end
end
