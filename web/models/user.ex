defmodule Trav.User do
  use Trav.Web, :model

  alias Trav.{Trip, Collaboration}

  schema "users" do
    field :name,         :string
    field :access_token, :string

    has_many :trips, Trip
    many_to_many :collaborated_trips, Trip, join_through: Collaboration

    timestamps
  end

  @allowed ~w(name access_token)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required(:name)
    |> validate_required(:access_token)
  end
end
