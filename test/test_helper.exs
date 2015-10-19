ExUnit.start
ExUnit.configure(timeout: 600_000)
require IEx

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Blog.Repo)

