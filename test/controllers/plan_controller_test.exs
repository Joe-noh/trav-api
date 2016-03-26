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
      |> put_req_header("authorization", "Bearer " <> JWT.encode(user))

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

  test "user cannot GET others' plan", %{conn: conn, trip: trip, plan: plan} do
    another_user = UserFactory.create(:user)
    response = conn
      |> put_req_header("authorization", "Bearer " <> JWT.encode(another_user))
      |> get(trip_plan_path(conn, :show, trip, plan))
      |> json_response(401)

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

  test "user cannot PUT others' plan", %{conn: conn, trip: trip, plan: plan} do
    another_user = UserFactory.create(:user)
    response = conn
      |> put_req_header("authorization", "Bearer " <> JWT.encode(another_user))
      |> put(trip_plan_path(conn, :show, trip, plan), plan: PlanFactory.fields_for(:plan))
      |> json_response(401)

    assert response["errors"] != %{}
  end

  test "DELETE a plan", %{conn: conn, trip: trip, plan: plan} do
    response = conn
      |> delete(trip_plan_path(conn, :delete, trip, plan))
      |> response(204)

    assert response
    refute Repo.get(Plan, plan.id)
  end

  test "user cannot DELETE others' plan", %{conn: conn, trip: trip, plan: plan} do
    another_user = UserFactory.create(:user)
    response = conn
      |> put_req_header("authorization", "Bearer " <> JWT.encode(another_user))
      |> delete(trip_plan_path(conn, :show, trip, plan))
      |> json_response(401)

    assert response["errors"] != %{}
  end
end
