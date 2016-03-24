defmodule Trav.AssignAuthPlugTest do
  use Trav.ConnCase, async: true

  alias Trav.{Plugs.AssignAuthPlug, User, JWT}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    user = %User{}
      |> User.changeset(%{name: "Joe_noh", access_token: "hogehoge"})
      |> Repo.insert!

    token = JWT.encode(%{user_id: user.id})

    {:ok, token: token}
  end

  test "the user is assigned if the token is valid", %{token: token} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> AssignAuthPlug.call([])

    assert conn.assigns.current_user != nil
  end

  test "the user is not assigned if the token is invalid", %{token: token} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{token}aaa")
      |> AssignAuthPlug.call([])

    assert conn.assigns.current_user == nil
  end
end
