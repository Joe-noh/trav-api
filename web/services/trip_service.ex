defmodule Trav.TripService do
  use Trav.Web, :service

  def build(user, title, body) do
    trip = user
      |> build_assoc(:trips)
      |> Trav.Trip.changeset(%{title: title})
      |> put_assoc(:plan, %Trav.Plan{body: body})
      |> put_assoc(:map,  %Trav.Map{})

    Multi.new
    |> Multi.insert(:trip, trip)
    |> Multi.run(:plan, fn changes ->
      changes.trip
      |> build_assoc(:plan)
      |> Trav.Plan.changeset(%{body: body})
      |> Repo.insert
    end)
    |> Multi.run(:map, fn changes ->
      changes.trip
      |> build_assoc(:map)
      |> Trav.Map.changeset
      |> Repo.insert
    end)
  end
end
