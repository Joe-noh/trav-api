defmodule Trav.Place do
  use Trav.Web, :model

  schema "places" do
    field :name, :string
    field :latitude, :decimal
    field :longitude, :decimal

    belongs_to :map, Trav.Map

    timestamps
  end

  @allowed ~w(name latitude longitude)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required(:name)
    |> validate_required(:latitude)
    |> validate_required(:longitude)
    |> validate_required(:map_id)
    |> assoc_constraint(:map)
  end
end
