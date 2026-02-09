defmodule ExTokenManagerApiWeb.WelcomeController do
  use ExTokenManagerApiWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{status: :ok, message: "Welcome to Token Management API"})
  end
end
