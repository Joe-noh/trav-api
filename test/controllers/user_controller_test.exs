defmodule Trav.UserControllerTest do
  use Trav.ConnCase, async: true

  alias Trav.{User, JWT}
  alias Trav.UserFactory

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    user = UserFactory.create(:user)
    conn = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer " <> JWT.encode(%{user_id: user.id}))

    {:ok, conn: conn, user: user}
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    response = conn
      |> get(user_path(conn, :show, user))
      |> json_response(200)

    assert response["data"] == %{"id" => user.id, "name" => user.name}
  end

  test "a user can see only him/herself", %{conn: conn, user: user} do
    another_user = UserFactory.create(:user)
    response = conn
      |> put_req_header("authorization", "Bearer " <> JWT.encode(%{user_id: another_user.id}))
      |> get(user_path(conn, :show, user))
      |> json_response(401)

    assert response["errors"] != %{}
  end

  test "return 401 if the user does not exist", %{conn: conn} do
    response = conn
      |> get(user_path(conn, :show, -1))
      |> json_response(401)

    assert response["errors"] != %{}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    response = conn
      |> post(user_path(conn, :create), user: UserFactory.fields_for(:user))
      |> json_response(201)

    assert response["data"]["id"]
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    response = conn
      |> post(user_path(conn, :create), user: UserFactory.fields_for(:invalid_user))
      |> json_response(422)

    assert response["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    response = conn
      |> put(user_path(conn, :update, user), user: UserFactory.fields_for(:user))
      |> json_response(200)

    assert response["data"]["id"]
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    response = conn
      |> put(user_path(conn, :update, user), user: UserFactory.fields_for(:invalid_user))
      |> json_response(422)

    assert response["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    response = conn
      |> delete(user_path(conn, :delete, user))
      |> response(204)

    assert response
    refute Repo.get(User, user.id)
  end
end
