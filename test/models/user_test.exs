defmodule Trav.UserTest do
  use Trav.ModelCase

  alias Trav.{User, UserFactory}

  setup do
    user = UserFactory.build(:user)

    {:ok, user: user}
  end

  test "changeset with valid attributes is valid", %{user: user} do
    changeset = User.changeset(user)
    assert changeset.valid?
  end

  test "name can't be blank", %{user: user} do
    changeset = User.changeset(user, %{name: ""})
    refute changeset.valid?
  end
end
