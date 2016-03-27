defmodule Trav.PlaceControllerTest do
  use Trav.ConnCase

  alias Trav.Place
  @valid_attrs %{latitude: "120.5", longitude: "120.5", name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, trip_place_path(conn, :index, trip)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    place = Repo.insert! %Place{}
    conn = get conn, trip_place_path(conn, :show, place)
    assert json_response(conn, 200)["data"] == %{"id" => place.id,
      "map_id" => place.map_id,
      "name" => place.name,
      "latitude" => place.latitude,
      "longitude" => place.longitude}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, trip_place_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, trip_place_path(conn, :create), place: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Place, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, trip_place_path(conn, :create), place: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    place = Repo.insert! %Place{}
    conn = put conn, trip_place_path(conn, :update, place), place: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Place, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    place = Repo.insert! %Place{}
    conn = put conn, trip_place_path(conn, :update, place), place: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    place = Repo.insert! %Place{}
    conn = delete conn, trip_place_path(conn, :delete, place)
    assert response(conn, 204)
    refute Repo.get(Place, place.id)
  end
end
