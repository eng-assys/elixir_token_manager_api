defmodule ExTokenManagerApi.Worker do
  use GenServer
  alias ExTokenManagerApi.Tokens

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def handle_info({:release, token_id}, state) do
    token = Tokens.show!(token_id)
    if token.status == "ACTIVE", do: Tokens.release_token(token)
    {:noreply, state}
  end
end
