defmodule Trav.Repo.Migrations.CreatePlace do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :name, :string
      add :latitude, :decimal
      add :longitude, :decimal
      add :map_id, references(:maps, on_delete: :nothing)

      timestamps
    end
    create index(:places, [:map_id])

  end
end
