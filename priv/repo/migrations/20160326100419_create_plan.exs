defmodule Trav.Repo.Migrations.CreatePlan do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :body, :text
      add :trip_id, references(:trips, on_delete: :nothing)

      timestamps
    end
    create index(:plans, [:trip_id])

  end
end
