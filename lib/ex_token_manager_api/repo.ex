defmodule ExTokenManagerApi.Repo do
  use Ecto.Repo,
    otp_app: :ex_token_manager_api,
    adapter: Ecto.Adapters.Postgres
end
