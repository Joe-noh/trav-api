defmodule Trav.Map do
  use Trav.Web, :model

  schema "maps" do
    belongs_to :trip, Trav.Trip

    timestamps
  end

  @allowed ~w()

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> assoc_constraint(:trip)
  end
end
