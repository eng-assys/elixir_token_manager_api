defmodule ExTokenManagerApiWeb.PageController do
  use ExTokenManagerApiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
