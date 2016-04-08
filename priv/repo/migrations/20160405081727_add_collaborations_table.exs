defmodule Trav.Repo.Migrations.AddCollaborationsTable do
  use Ecto.Migration

  def change do
    create table(:collaborations) do
      add :trip_id, references(:trips, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end

    create unique_index(:collaborations, [:trip_id, :user_id])
  end
end
