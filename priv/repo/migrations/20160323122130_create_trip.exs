defmodule Trav.Repo.Migrations.CreateTrip do
  use Ecto.Migration

  def change do
    create table(:trips) do
      add :title, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:trips, [:user_id])

  end
end
