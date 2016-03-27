defmodule Trav.Place do
  use Trav.Web, :model

  schema "places" do
    field :name, :string
    field :latitude, :decimal
    field :longitude, :decimal
    belongs_to :map, Trav.Map

    timestamps
  end

  @required_fields ~w(name latitude longitude)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
