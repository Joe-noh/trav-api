defmodule Trav.PlanControllerTest do
  use Trav.ConnCase

  alias Trav.{UserFactory, TripFactory, PlanFactory}
  alias Trav.JWT

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    user = UserFactory.create(:user)
    trip = TripFactory.create(:trip, user: user)
    plan = PlanFactory.create(:plan, trip: trip)
    conn = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", user |> JWT.encode |> JWT.bearer)

    {:ok, [conn: conn, trip: trip, plan: plan]}
  end

  test "PUT a valid plan", %{conn: conn, trip: trip, plan: plan} do
    response = conn
      |> put(trip_plan_path(conn, :update, trip, plan), plan: PlanFactory.fields_for(:plan))
      |> json_response(200)

    assert response["data"]["id"]
  end

  test "PUT an invalid plan", %{conn: conn, trip: trip, plan: plan} do
    response = conn
      |> put(trip_plan_path(conn, :update, trip, plan), plan: PlanFactory.fields_for(:invalid_plan))
      |> json_response(422)

    assert response["errors"] != %{}
  end

  test "user cannot PUT others' plan", %{conn: conn, trip: trip, plan: plan} do
    another_user = UserFactory.create(:user)
    response = conn
      |> put_req_header("authorization", another_user |> JWT.encode |> JWT.bearer)
      |> put(trip_plan_path(conn, :update, trip, plan), plan: PlanFactory.fields_for(:plan))
      |> json_response(401)

    assert response["errors"] != %{}
  end
end
