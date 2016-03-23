defmodule Trav.UserTest do
  use Trav.ModelCase

  alias Trav.User

  @valid_attrs %{name: "Joe_noh", access_token: String.duplicate("a", 100)}
  @invalid_attrs %{}

  test "changeset with valid attributes is valid" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "name can't be blank" do
    changeset = User.changeset(%User{}, %{@valid_attrs | name: ""})
    refute changeset.valid?
  end

  test "access_token can't be blank" do
    changeset = User.changeset(%User{}, %{@valid_attrs | access_token: ""})
    refute changeset.valid?
  end

  test "changeset with invalid attributes is invalid" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
