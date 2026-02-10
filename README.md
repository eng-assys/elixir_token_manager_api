# ExTokenManagerApi

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

* Update Dependencies `mix deps.get`

## Generate Database Migration
```bash
mix ecto.gen.migration add_users_table

mix ecto.migrate
```

## Running Seed
```bash
mix run priv/repo/seeds.exs
```

## Compile Swagger docs
```bash
mix deps.compile phoenix_swagger
```

## Access Swagger Documentation
[Swagger](http://localhost:4000/api/swagger)