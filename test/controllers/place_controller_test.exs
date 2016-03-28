defmodule Trav.PlaceControllerTest do
  use Trav.ConnCase

  alias Trav.Place
  alias Trav.{TripFactory, PlaceFactory}

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    trip = TripFactory.create(:trip)
    place = PlaceFactory.create(:place, map: trip.map)
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, %{conn: conn, trip: trip, place: place}}
  end

  test "lists all entries on index", %{conn: conn, trip: trip} do
    conn = get conn, trip_place_path(conn, :index, trip)
    assert json_response(conn, 200)["data"] |> is_list
  end

  test "shows chosen resource", %{conn: conn, trip: trip, place: place} do
    conn = get conn, trip_place_path(conn, :show, trip, place)
    assert json_response(conn, 200)["data"] == %{"id" => place.id,
      "map_id" => place.map_id,
      "name" => place.name,
      "latitude" => to_string(place.latitude),
      "longitude" => to_string(place.longitude)
    }
  end

  test "creates and renders resource when data is valid", %{conn: conn, trip: trip} do
    name = "首里城"
    params = PlaceFactory.fields_for(:place, name: name)
    conn = post(conn, trip_place_path(conn, :create, trip), place: params)

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Place, name: name)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, trip: trip} do
    conn = post conn, trip_place_path(conn, :create, trip), place: PlaceFactory.fields_for(:invalid_place)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, trip: trip, place: place} do
    name = "首里城"
    params = PlaceFactory.fields_for(:place, name: name)
    conn = put conn, trip_place_path(conn, :update, trip, place), place: params

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Place, name: name)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, trip: trip, place: place} do
    conn = put conn, trip_place_path(conn, :update, trip, place), place: PlaceFactory.fields_for(:invalid_place)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, trip: trip, place: place} do
    conn = delete conn, trip_place_path(conn, :delete, trip, place)
    assert response(conn, 204)
    refute Repo.get(Place, place.id)
  end
end
