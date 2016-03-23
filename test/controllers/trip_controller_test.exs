defmodule Trav.TripControllerTest do
  use Trav.ConnCase, async: true

  alias Trav.{User, Trip}

  @valid_attrs %{title: "福井旅行"}
  @invalid_attrs %{title: ""}

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    user = %User{}
      |> User.changeset(%{name: "Joe_noh", access_token: "hogehoge"})
      |> Repo.insert!
    trip = %Trip{user_id: user.id}
      |> Trip.changeset(@valid_attrs)
      |> Repo.insert!
      |> Repo.preload(:user)

    {:ok, conn: put_req_header(conn, "accept", "application/json"), trip: trip}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, trip_path(conn, :index)
    assert json_response(conn, 200)["data"] |> length == 1
  end

  test "shows chosen resource", %{conn: conn, trip: trip} do
    conn = get conn, trip_path(conn, :show, trip)
    assert json_response(conn, 200)["data"] == %{"id" => trip.id,
      "title" => trip.title,
      "user_id" => trip.user_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, trip_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, trip: trip} do
    conn = post conn, trip_path(conn, :create), trip: Map.put(@valid_attrs, :user_id, trip.user.id)
    assert json_response(conn, 201)["data"]["id"]

    title = Map.get(@valid_attrs, :title)
    assert from(t in Trip, where: t.title == ^title) |> Ecto.Query.first |> Repo.one
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, trip: trip} do
    conn = post conn, trip_path(conn, :create), trip: Map.put(@invalid_attrs, :user_id, trip.user.id)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, trip: trip} do
    conn = put conn, trip_path(conn, :update, trip), trip: Map.put(@valid_attrs, :user_id, trip.user.id)
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Trip, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, trip: trip} do
    conn = put conn, trip_path(conn, :update, trip), trip: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, trip: trip} do
    conn = delete conn, trip_path(conn, :delete, trip)
    assert response(conn, 204)
    refute Repo.get(Trip, trip.id)
  end
end
