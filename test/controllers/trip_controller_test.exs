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
    response = conn
      |> get(trip_path(conn, :index))
      |> json_response(200)

    assert response["data"] |> length == 1
  end

  test "shows chosen resource", %{conn: conn, trip: trip} do
    response = conn
      |> get(trip_path(conn, :show, trip))
      |> json_response(200)

    assert response["data"] == %{
      "id" => trip.id,
      "title" => trip.title,
      "user_id" => trip.user_id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get(conn, trip_path(conn, :show, -1))
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: user} do
    response = conn
      |> post(trip_path(conn, :create), trip: TripFactory.fields_for(:trip, user_id: user.id))
      |> json_response(201)

    assert response["data"]["id"]

    title = TripFactory.fields_for(:trip) |> Map.get(:title)
    assert from(t in Trip, where: t.title == ^title) |> Ecto.Query.first |> Repo.one
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    response = conn
      |> post(trip_path(conn, :create), trip: TripFactory.fields_for(:invalid_trip))
      |> json_response(422)

    assert response["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, trip: trip, user: user} do
    response = conn
      |> put(trip_path(conn, :update, trip), trip: TripFactory.fields_for(:trip, user_id: user.id))
      |> json_response(200)

    assert response["data"]["id"]
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, trip: trip} do
    response = conn
      |> put(trip_path(conn, :update, trip), trip: TripFactory.fields_for(:invalid_trip))
      |> json_response(422)

    assert response["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, trip: trip} do
    response = conn
      |> delete(trip_path(conn, :delete, trip))
      |> response(204)

    assert response
    refute Repo.get(Trip, trip.id)
  end
end
