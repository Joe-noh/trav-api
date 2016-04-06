defmodule Trav.CollaboratorControllerTest do
  use Trav.ConnCase, async: true

  alias Trav.{UserFactory, TripFactory}
  alias Trav.JWT

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    user = UserFactory.create(:user)
    trip = TripFactory.create(:trip, user: user)
    conn = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", user |> JWT.encode |> JWT.bearer)

    {:ok, [
      conn: conn,
      trip: trip,
      user: user
    ]}
  end

  test "POST a collaborator", %{conn: conn, trip: trip} do
    another_user = UserFactory.create(:user)
    response = conn
      |> post(trip_collaborator_path(conn, :create, trip), collaborator_id: another_user.id)
      |> json_response(201)

    assert response["data"]
  end

  test "POST twice doesn't change num of collaborators", %{conn: conn, trip: trip} do
    another_user = UserFactory.create(:user)

    conn |> post(trip_collaborator_path(conn, :create, trip), collaborator_id: another_user.id)
    assert trip |> Repo.preload(:collaborators) |> Map.get(:collaborators) |> length == 1

    conn |> post(trip_collaborator_path(conn, :create, trip), collaborator_id: another_user.id)
    assert trip |> Repo.preload(:collaborators) |> Map.get(:collaborators) |> length == 1
  end
end
