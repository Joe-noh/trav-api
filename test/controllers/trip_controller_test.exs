defmodule Trav.TripControllerTest do
  use Trav.ConnCase, async: true

  alias Trav.{UserFactory, TripFactory}
  alias Trav.{Trip, JWT}

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    user = UserFactory.create(:user)
    trip = TripFactory.create(:trip, user: user)
    conn = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer " <> JWT.encode(%{user_id: user.id}))

    {:ok, [
      conn: conn,
      trip: trip,
      user: user
    ]}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, trip_path(conn, :index)
    assert json_response(conn, 200)["data"] |> length == 1
  end

  test "shows chosen resource", %{conn: conn, trip: trip} do
    conn = get conn, trip_path(conn, :show, trip)
    assert json_response(conn, 200)["data"] == %{
      "id" => trip.id,
      "title" => trip.title,
      "user_id" => trip.user_id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, trip_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: user} do
    conn = post conn, trip_path(conn, :create), trip: TripFactory.fields_for(:trip, user_id: user.id)
    assert json_response(conn, 201)["data"]["id"]

    title = TripFactory.fields_for(:trip) |> Map.get(:title)
    assert from(t in Trip, where: t.title == ^title) |> Ecto.Query.first |> Repo.one
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, trip_path(conn, :create), trip: TripFactory.fields_for(:invalid_trip)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, trip: trip, user: user} do
    conn = put conn, trip_path(conn, :update, trip), trip: TripFactory.fields_for(:trip, user_id: user.id)

    assert json_response(conn, 200)["data"]["id"]
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, trip: trip} do
    conn = put conn, trip_path(conn, :update, trip), trip: TripFactory.fields_for(:invalid_trip)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, trip: trip} do
    conn = delete conn, trip_path(conn, :delete, trip)
    assert response(conn, 204)
    refute Repo.get(Trip, trip.id)
  end
end
