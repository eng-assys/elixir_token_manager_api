# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExTokenManagerApi.Repo.insert!(%ExTokenManagerApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ExTokenManagerApi.Repo
alias ExTokenManagerApi.Tokens.{Token, TokenUsageHistory}

Repo.delete_all(TokenUsageHistory)
Repo.delete_all(Token)

IO.puts("Generating 100 tokens...")

for _ <- 1..10 do
  user_id = Ecto.UUID.generate()

  token =
    Repo.insert!(%Token{
      status: "ACTIVE",
      current_user_id: user_id
    })

  Repo.insert!(%TokenUsageHistory{
    token_id: token.id,
    user_id: user_id,
    activated_at: DateTime.utc_now() |> DateTime.truncate(:second)
  })
end

for _ <- 1..90 do
  Repo.insert!(%Token{
    status: "AVAILABLE",
    current_user_id: nil
  })
end

IO.puts("Seeds succeeded!")
IO.puts("- 10 active tokens with history.")
IO.puts("- 90 available tokens.")
