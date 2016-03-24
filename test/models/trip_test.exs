defmodule Trav.TripTest do
  use Trav.ModelCase

  alias Trav.Trip
  alias Trav.{UserFactory, TripFactory}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    user = UserFactory.create(:user)
    trip = TripFactory.build(:trip, user_id: user.id)
    {:ok, user: user, trip: trip}
  end

  test "changeset with valid attributes", %{trip: trip} do
    changeset = Trip.changeset(trip)
    assert changeset.valid?
  end

  test "title can't be blank", %{trip: trip} do
    changeset = Trip.changeset(trip, %{title: ""})
    refute changeset.valid?
  end

  test "user_id can't be blank", %{trip: trip} do
    changeset = Trip.changeset(trip, %{user_id: nil})
    refute changeset.valid?
  end
end
