defmodule Trav.UserFactory do
  use ExMachina.Ecto, repo: Trav.Repo

  alias Trav.User

  def factory(:user) do
    %User{
      name: "Joe_noh"
    }
  end

  def factory(:invalid_user) do
    %User{name: ""}
  end
end
