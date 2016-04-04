defmodule Trav.PlaceControllerTest do
  use Trav.ConnCase

  alias Trav.{Place, JWT}
  alias Trav.{UserFactory, TripFactory, PlaceFactory}

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    user = UserFactory.create(:user)
    trip = TripFactory.create(:trip, user: user)
    place = PlaceFactory.create(:place, map: trip.map)
    conn = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", user |> JWT.encode |> JWT.bearer)

    {:ok, %{conn: conn, trip: trip, place: place}}
  end

  test "GET all places", %{conn: conn, trip: trip} do
    response = conn
      |> get(trip_place_path(conn, :index, trip))
      |> json_response(200)

    assert response["data"] |> is_list
  end

  test "not granted user can't GET all places", %{conn: conn, trip: trip} do
    another_user = UserFactory.create(:user)
    response = conn
      |> put_req_header("authorization", another_user |> JWT.encode |> JWT.bearer)
      |> get(trip_place_path(conn, :index, trip))
      |> json_response(401)

    assert response["errors"] != %{}
  end

  test "GET a place", %{conn: conn, trip: trip, place: place} do
    response = conn
      |> get(trip_place_path(conn, :show, trip, place))
      |> json_response(200)

    assert response["data"] == %{
      "id" => place.id,
      "map_id" => place.map_id,
      "name" => place.name,
      "latitude" => to_string(place.latitude),
      "longitude" => to_string(place.longitude)
    }
  end

  test "not granted user can't GET a place", %{conn: conn, trip: trip, place: place} do
    another_user = UserFactory.create(:user)
    response = conn
      |> put_req_header("authorization", another_user |> JWT.encode |> JWT.bearer)
      |> get(trip_place_path(conn, :show, trip, place))
      |> json_response(401)

    assert response["errors"] != %{}
  end

  test "POST a valid place", %{conn: conn, trip: trip} do
    name = "首里城"
    params = PlaceFactory.fields_for(:place, name: name)
    response = conn
      |> post(trip_place_path(conn, :create, trip), place: params)
      |> json_response(201)

    assert response["data"]["id"]
    assert Repo.get_by(Place, name: name)
  end

  test "POST an invalid place", %{conn: conn, trip: trip} do
    params = PlaceFactory.fields_for(:invalid_place)
    response = conn
      |> post(trip_place_path(conn, :create, trip), place: params)
      |> json_response(422)

    assert response["errors"] != %{}
  end

  test "not granted user can't POST a place", %{conn: conn, trip: trip} do
    another_user = UserFactory.create(:user)
    params = PlaceFactory.fields_for(:place)
    response = conn
      |> put_req_header("authorization", another_user |> JWT.encode |> JWT.bearer)
      |> post(trip_place_path(conn, :create, trip), place: params)
      |> json_response(401)

    assert response["errors"] != %{}
  end

  test "PUT a valid place", %{conn: conn, trip: trip, place: place} do
    name = "首里城"
    params = PlaceFactory.fields_for(:place, name: name)
    response = conn
      |> put(trip_place_path(conn, :update, trip, place), place: params)
      |> json_response(200)

    assert response["data"]["id"]
    assert Repo.get_by(Place, name: name)
  end

  test "PUT an invalid place", %{conn: conn, trip: trip, place: place} do
    params = PlaceFactory.fields_for(:invalid_place)
    response = conn
      |> put(trip_place_path(conn, :update, trip, place), place: params)
      |> json_response(422)

    assert response["errors"] != %{}
  end

  test "not granted user can't POST a place", %{conn: conn, trip: trip, place: place} do
    another_user = UserFactory.create(:user)
    params = PlaceFactory.fields_for(:place)
    response = conn
      |> put_req_header("authorization", another_user |> JWT.encode |> JWT.bearer)
      |> put(trip_place_path(conn, :update, trip, place), place: params)
      |> json_response(401)

    assert response["errors"] != %{}
  end

  test "DELETE a place", %{conn: conn, trip: trip, place: place} do
    response = conn
      |> delete(trip_place_path(conn, :delete, trip, place))
      |> response(204)

    assert response
    refute Repo.get(Place, place.id)
  end

  test "not granted user can't DELETE a place", %{conn: conn, trip: trip, place: place} do
    another_user = UserFactory.create(:user)
    response = conn
      |> put_req_header("authorization", another_user |> JWT.encode |> JWT.bearer)
      |> delete(trip_place_path(conn, :delete, trip, place))
      |> json_response(401)

    assert response["errors"] != %{}
  end
end
