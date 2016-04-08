defmodule Trav.CollaborationFactory do
  use ExMachina.Ecto, repo: Trav.Repo

  alias Trav.{UserFactory, TripFactory}
  alias Trav.Collaboration

  def factory(:collaboration) do
    %Collaboration{
      user: UserFactory.build(:user),
      trip: TripFactory.build(:trip)
    }
  end
end
