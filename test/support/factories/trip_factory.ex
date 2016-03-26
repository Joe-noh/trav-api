defmodule Trav.TripFactory do
  use ExMachina.Ecto, repo: Trav.Repo

  alias Trav.UserFactory
  alias Trav.Trip

  def factory(:trip) do
    %Trip{
      title: "旅行",
      user: UserFactory.build(:user)
    }
  end

  def factory(:invalid_trip) do
    %Trip{title: "", user_id: nil}
  end
end
