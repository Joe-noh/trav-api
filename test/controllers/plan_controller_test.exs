defmodule Trav.PlanControllerTest do
  use Trav.ConnCase

  alias Trav.{UserFactory, TripFactory, PlanFactory}
  alias Trav.{Plan, JWT}

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    user = UserFactory.create(:user)
    trip = TripFactory.create(:trip, user: user)
    plan = PlanFactory.create(:plan, trip: trip)
    conn = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer " <> JWT.encode(%{user_id: user.id}))

    {:ok, [conn: conn, trip: trip, plan: plan]}
  end

  test "GET a plan", %{conn: conn, trip: trip, plan: plan} do
    response = conn
      |> get(trip_plan_path(conn, :show, trip, plan))
      |> json_response(200)

    assert response["data"] == %{
      "id" => plan.id,
      "body" => plan.body,
      "trip_id" => plan.trip_id
    }
  end

  test "POST a valid plan", %{conn: conn, trip: trip} do
    response = conn
      |> post(trip_plan_path(conn, :create, trip), plan: PlanFactory.fields_for(:plan))
      |> json_response(201)

    assert response["data"]["id"]
  end

  test "POST an invalid plan", %{conn: conn, trip: trip} do
    response = conn
      |> post(trip_plan_path(conn, :create, trip), plan: PlanFactory.fields_for(:invalid_plan))
      |> json_response(422)

    assert response["errors"] != %{}
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

  test "deletes chosen resource", %{conn: conn, trip: trip, plan: plan} do
    response = conn
      |> delete(trip_plan_path(conn, :delete, trip, plan))
      |> response(204)

    assert response
    refute Repo.get(Plan, plan.id)
  end
end
