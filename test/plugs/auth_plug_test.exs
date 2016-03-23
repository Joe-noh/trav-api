defmodule Trav.AuthPlugTest do
  use Trav.ConnCase, async: true

  alias Trav.{Plugs.AuthPlug, User}

  @secret "hogehogefugafuga"

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    user = %User{}
      |> User.changeset(%{name: "Joe_noh", access_token: "hogehoge"})
      |> Repo.insert!

    token = %{user_id: user.id}
      |> Joken.token
      |> Joken.with_signer(Joken.hs256 @secret)
      |> Joken.sign
      |> Joken.get_compact

    {:ok, token: token}
  end

  test "the user is assigned if the token is valid", %{token: token} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> AuthPlug.call(@secret)

    assert conn.assigns.current_user != nil
  end

  test "the user is not assigned if the token is invalid", %{token: token} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> AuthPlug.call(@secret <> "aaa")

    assert conn.assigns.current_user == nil
  end
end
