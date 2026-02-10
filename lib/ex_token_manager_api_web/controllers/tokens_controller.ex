defmodule ExTokenManagerApiWeb.TokensController do
  use ExTokenManagerApiWeb, :controller
  use PhoenixSwagger

  alias ExTokenManagerApi.Tokens

  def swagger_definitions do
    %{
      Token:
        swagger_schema do
          title("Token")
          description("A token to access an resource")

          properties do
            id(:string, "Token's UUID", format: :uuid)
            status(:string, "Status (ACTIVE/AVAILABLE)", example: "ACTIVE")
            user_id(:string, "Current User ID", format: :uuid)
          end
        end
    }
  end

  def clear_active(conn, _params) do
    with {:ok, results} <- Tokens.clear_active_and_release_histories() do
      conn
      |> put_status(:ok)
      |> render(:clear_active, results: results)
    end
  end

  def claim(conn, %{"user_id" => user_id}) do
    with {:ok, token} <- Tokens.claim(user_id) do
      conn
      |> put_status(:created)
      |> render(:show, token: token)
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

    response(200, "OK", Schema.ref(:Token))
  end

  def history(conn, %{"id" => id}) do
    with {:ok, token_histories} <- {:ok, Tokens.show_histories!(id)} do
      conn
      |> put_status(:ok)
      |> render(:histories, token_histories: token_histories)
    end
  end
end
