defmodule Trav.Repo.Migrations.RemoveAccessTokenFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :access_token
    end
  end
end
