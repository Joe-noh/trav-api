defmodule Trav.TripTest do
  use Trav.ModelCase

  alias Trav.{User, Trip}

  @valid_attrs %{title: "福井旅行"}
  @invalid_attrs %{title: ""}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    user = User.changeset(%User{}, %{name: "Joe_noh", access_token: "hogehoge"}) |> Repo.insert!
    {:ok, user: user}
  end

  test "changeset with valid attributes", %{user: user} do
    changeset = Trip.changeset(%Trip{user_id: user.id}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes", %{user: user} do
    changeset = Trip.changeset(%Trip{user_id: user.id}, @invalid_attrs)
    refute changeset.valid?
  end
end
