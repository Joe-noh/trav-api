defmodule Trav.PlaceTest do
  use Trav.ModelCase

  alias Trav.Place
  alias Trav.{PlaceFactory, MapFactory}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    map = MapFactory.create(:map)
    place = PlaceFactory.build(:place, map_id: map.id)

    {:ok, %{place: place}}
  end

  test "changeset with valid attributes", %{place: place} do
    changeset = Place.changeset(place)
    assert changeset.valid?
  end

  test "name can't be blank", %{place: place} do
    changeset = Place.changeset(place, %{name: " "})
    refute changeset.valid?
  end

  test "latitude can't be blank", %{place: place} do
    changeset = Place.changeset(place, %{latitude: nil})
    refute changeset.valid?
  end

  test "longitude can't be blank", %{place: place} do
    changeset = Place.changeset(place, %{longitude: nil})
    refute changeset.valid?
  end
end
