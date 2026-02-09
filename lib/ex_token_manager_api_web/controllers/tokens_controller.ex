defmodule ExTokenManagerApiWeb.TokensController do
  use ExTokenManagerApiWeb, :controller

  alias ExTokenManagerApi.Tokens

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

  def history(conn, %{"id" => id}) do
    with {:ok, token_histories} <- {:ok, Tokens.show_histories!(id)} do
      conn
      |> put_status(:ok)
      |> render(:histories, token_histories: token_histories)
    end
  end
end
