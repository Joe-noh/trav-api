defmodule Trav.TripFactory do
  use ExMachina.Ecto, repo: Trav.Repo

  alias Trav.{UserFactory, PlanFactory}
  alias Trav.Trip

  def factory(:trip) do
    %Trip{
      title: "旅行",
      user: UserFactory.build(:user),
      plan: PlanFactory.build(:plan)
    }
  end

  def factory(:invalid_trip) do
    %Trip{title: "", user_id: nil}
  end
end
