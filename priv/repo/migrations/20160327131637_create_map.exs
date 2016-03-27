defmodule Trav.Repo.Migrations.CreateMap do
  use Ecto.Migration

  def change do
    create table(:maps) do
      add :trip_id, references(:trips, on_delete: :nothing)

      timestamps
    end
    create index(:maps, [:trip_id])

  end
end
