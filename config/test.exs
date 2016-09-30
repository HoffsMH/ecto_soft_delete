use Mix.Config

config :ecto_soft_delete, ecto_repos: [Ecto.SoftDelete.Test.Repo]

config :ecto_soft_delete, Ecto.SoftDelete.Test.Repo,
  database: "soft_delete_test",
  hostname: "localhost",
  port: 15432,
  adapter: Ecto.Adapters.Postgres
