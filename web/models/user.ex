defmodule Trav.User do
  use Trav.Web, :model

  alias Trav.{Trip, Collaboration}

  schema "users" do
    field :name,         :string

    has_many :trips, Trip
    many_to_many :collaborated_trips, Trip, join_through: Collaboration

    timestamps
  end

  @allowed ~w(name)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required(:name)
  end
end
