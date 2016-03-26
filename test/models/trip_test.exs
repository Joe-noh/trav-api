defmodule Trav.TripTest do
  use Trav.ModelCase

  alias Trav.{Trip, TripFactory}

  setup do
    trip = TripFactory.build(:trip)

    {:ok, trip: trip}
  end

  test "changeset with valid attributes", %{trip: trip} do
    changeset = Trip.changeset(trip)
    assert changeset.valid?
  end

  test "title can't be blank", %{trip: trip} do
    changeset = Trip.changeset(trip, %{title: ""})
    refute changeset.valid?
  end
end
