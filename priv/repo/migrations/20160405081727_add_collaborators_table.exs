defmodule Trav.Repo.Migrations.AddCollaboratorsTable do
  use Ecto.Migration

  def change do
    create table(:collaborators) do
      add :trip_id, references(:trips, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end

    create index(:collaborators, [:trip_id, :user_id])
  end
end
