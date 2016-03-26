defmodule Trav.UserFactory do
  use ExMachina.Ecto, repo: Trav.Repo

  alias Trav.User

  def factory(:user) do
    %User{
      name: "Joe_noh",
      access_token: String.duplicate("a", 100)
    }
  end

  def factory(:invalid_user) do
    %User{name: "", access_token: ""}
  end
end
