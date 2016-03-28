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
    response = conn
      |> get(trip_place_path(conn, :index, trip))
      |> json_response(200)

    assert response["data"] |> is_list
  end

  test "shows chosen resource", %{conn: conn, trip: trip, place: place} do
    response = conn
      |> get(trip_place_path(conn, :show, trip, place))
      |> json_response(200)

    assert response["data"] == %{"id" => place.id,
      "map_id" => place.map_id,
      "name" => place.name,
      "latitude" => to_string(place.latitude),
      "longitude" => to_string(place.longitude)
    }
  end

  test "creates and renders resource when data is valid", %{conn: conn, trip: trip} do
    name = "首里城"
    params = PlaceFactory.fields_for(:place, name: name)
    response = conn
      |> post(trip_place_path(conn, :create, trip), place: params)
      |> json_response(201)

    assert response["data"]["id"]
    assert Repo.get_by(Place, name: name)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, trip: trip} do
    response = conn
      |> post(trip_place_path(conn, :create, trip), place: PlaceFactory.fields_for(:invalid_place))
      |> json_response(422)

    assert response["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, trip: trip, place: place} do
    name = "首里城"
    params = PlaceFactory.fields_for(:place, name: name)
    response = conn
      |> put(trip_place_path(conn, :update, trip, place), place: params)
      |> json_response(200)

    assert response["data"]["id"]
    assert Repo.get_by(Place, name: name)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, trip: trip, place: place} do
    response = conn
      |> put(trip_place_path(conn, :update, trip, place), place: PlaceFactory.fields_for(:invalid_place))
      |> json_response(422)

    assert response["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, trip: trip, place: place} do
    response = conn
      |> delete(trip_place_path(conn, :delete, trip, place))
      |> response(204)

    assert response
    refute Repo.get(Place, place.id)
  end
end
