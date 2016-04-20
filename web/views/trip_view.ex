defmodule Trav.TripView do
  use Trav.Web, :view

  def render("index.json", %{trips: trips}) do
    %{trips: render_many(trips, Trav.TripView, "trip.json")}
  end

  def render("show.json", %{trip: trip}) do
    %{trip: render_one(trip, Trav.TripView, "trip.json")}
  end

  def render("trip.json", %{trip: trip}) do
    %{
      id: trip.id,
      title: trip.title,
      user_id: trip.user_id,
      plan: render_one(trip.plan, Trav.PlanView, "plan.json"),
      map: render_one(trip.map, Trav.MapView, "map.json")
    }
  end
end
