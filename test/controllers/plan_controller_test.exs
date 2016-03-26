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

    {:ok, [conn: conn, user: user, trip: trip, plan: plan]}
  end

  test "shows chosen resource", %{conn: conn, trip: trip, plan: plan} do
    conn = get conn, trip_plan_path(conn, :show, trip, plan)
    assert json_response(conn, 200)["data"] == %{"id" => plan.id,
      "body" => plan.body,
      "trip_id" => plan.trip_id}
  end

  test "creates and renders resource when data is valid", %{conn: conn, trip: trip} do
    conn = post conn, trip_plan_path(conn, :create, trip), plan: PlanFactory.fields_for(:plan)
    assert json_response(conn, 201)["data"]["id"]
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, trip: trip} do
    conn = post conn, trip_plan_path(conn, :create, trip), plan: PlanFactory.fields_for(:invalid_plan)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, trip: trip, plan: plan} do
    conn = put conn, trip_plan_path(conn, :update, trip, plan), plan: PlanFactory.fields_for(:plan)
    assert json_response(conn, 200)["data"]["id"]
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, trip: trip, plan: plan} do
    conn = put conn, trip_plan_path(conn, :update, trip, plan), plan: PlanFactory.fields_for(:invalid_plan)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, trip: trip, plan: plan} do
    conn = delete conn, trip_plan_path(conn, :delete, trip, plan)
    assert response(conn, 204)
    refute Repo.get(Plan, plan.id)
  end
end
