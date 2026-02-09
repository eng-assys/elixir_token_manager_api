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
end
