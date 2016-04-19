defmodule Trav.Map do
  use Trav.Web, :model

  schema "maps" do
    belongs_to :trip, Trav.Trip
    has_many :places, Trav.Place, on_delete: :delete_all

    timestamps
  end

  @allowed ~w()

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> foreign_key_constraint(:trip_id)
  end
end
