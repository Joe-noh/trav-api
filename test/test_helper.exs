ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Trav.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Trav.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Trav.Repo)

