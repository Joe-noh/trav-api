defmodule Trav.UserControllerTest do
  use Trav.ConnCase, async: true
  import Trav.UserFactory

  alias Trav.User

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)

    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = create(:user)
    conn = get conn, user_path(conn, :show, user)

    assert json_response(conn, 200)["data"] == %{"id" => user.id, "name" => user.name}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: fields_for(:user)

    assert json_response(conn, 201)["data"]["id"]
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: fields_for(:invalid_user)

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = create(:user)
    conn = put conn, user_path(conn, :update, user), user: fields_for(:user)

    assert json_response(conn, 200)["data"]["id"]
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = create(:user)
    conn = put conn, user_path(conn, :update, user), user: fields_for(:invalid_user)

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = create(:user)
    conn = delete conn, user_path(conn, :delete, user)

    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
