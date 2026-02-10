defmodule ExTokenManagerApi.Worker do
  require Logger

  use GenServer
  alias ExTokenManagerApi.Tokens

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    schedule_cleanup()
    {:ok, state}
  end

  def handle_info({:release, token_id}, state) do
    Logger.info("Releasing token: #{token_id}")

    token = Tokens.show!(token_id)
    if token.status == "ACTIVE", do: Tokens.release_token(token)
    {:noreply, state}
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup_task, 60 * 1000)
  end
end
