defmodule Trav.PlaceFactory do
  use ExMachina.Ecto, repo: Trav.Repo

  alias Trav.Place

  def factory(:place) do
    %Place{
      name: "恐竜博物館",
      latitude: Decimal.new(36.082696),
      longitude: Decimal.new(136.506553)
    }
  end

  def factory(:invalid_place) do
    %Place{name: "", latitude: nil, longitude: nil}
  end
end
