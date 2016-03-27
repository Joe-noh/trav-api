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
      |> put_req_header("authorization", "Bearer " <> JWT.encode(user))

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

    assert response["data"]["id"]
    assert response["data"]["title"]
    assert response["data"]["plan"]
  end

  test "outsider can't see trips", %{conn: conn, trip: trip} do
    another_user = UserFactory.create(:user)
    response = conn
      |> put_req_header("authorization", "Bearer " <> JWT.encode(another_user))
      |> get(trip_path(conn, :show, trip))
      |> json_response(401)

    assert response["errors"] != %{}
  end

  test "return 401 if the trip does not exist", %{conn: conn} do
    response = conn
      |> get(trip_path(conn, :show, -1))
      |> json_response(401)

    assert response["errors"] != %{}
  end

  test "POST a trip", %{conn: conn} do
    title = "沖縄旅行"
    params = TripFactory.fields_for(:trip, title: title)
    response = conn
      |> post(trip_path(conn, :create), trip: params)
      |> json_response(201)

    assert response["data"]["id"]
    assert response["data"]["plan"]

    trip = (from t in Trip, where: t.title == ^title, preload: :plan) |> Repo.one

    assert trip
    assert trip.plan
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

  test "outsider can't update trips", %{conn: conn, trip: trip} do
    another_user = UserFactory.create(:user)
    response = conn
      |> put_req_header("authorization", "Bearer " <> JWT.encode(another_user))
      |> put(trip_path(conn, :update, trip), trip: TripFactory.fields_for(:trip))
      |> json_response(401)

    assert response["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, trip: trip} do
    response = conn
      |> delete(trip_path(conn, :delete, trip))
      |> response(204)

    assert response
    refute Repo.get(Trip, trip.id)
  end

  test "outsider can't delete trips", %{conn: conn, trip: trip} do
    another_user = UserFactory.create(:user)
    response = conn
      |> put_req_header("authorization", "Bearer " <> JWT.encode(another_user))
      |> delete(trip_path(conn, :delete, trip))
      |> json_response(401)

    assert response["errors"] != %{}
  end
end
