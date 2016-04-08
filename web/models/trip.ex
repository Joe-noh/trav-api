defmodule Trav.Trip do
  use Trav.Web, :model

  alias Trav.{User, Trip, Plan, Map, Collaboration}
  alias Ecto.Multi

  schema "trips" do
    field :title, :string

    belongs_to :user, User
    has_one :plan, Plan, on_delete: :delete_all
    has_one :map,  Map,  on_delete: :delete_all
    many_to_many :collaborators, User, join_through: Collaboration,
      on_delete: :delete_all,
      on_replace: :delete

    timestamps
  end

  @allowed ~w(title)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required(:title)
    |> assoc_constraint(:user)
  end

  def build_multi(user, params) do
    trip = user
      |> build_assoc(:trips)
      |> Trip.changeset(params)
      |> put_assoc(:plan, %Plan{})
      |> put_assoc(:map,  %Map{})

    Multi.new |> Multi.insert(:trip, trip)
  end

  def add_collaborator(trip, user) do
    collaborators = Enum.map([user | trip.collaborators], &Ecto.Changeset.change/1)
    trip = changeset(trip) |> put_assoc(:collaborators, collaborators)

    Multi.new |> Multi.update(:trip, trip)
  end

  def del_collaborator(trip, user) do
    collaborators = trip.collaborators
      |> Enum.filter_map(fn c -> c.id != user.id end, &Ecto.Changeset.change/1)
    trip = changeset(trip) |> put_assoc(:collaborators, collaborators)

    Multi.new |> Multi.update(:trip, trip)
  end
end
