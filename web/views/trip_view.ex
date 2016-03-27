defmodule Trav.TripView do
  use Trav.Web, :view

  def render("index.json", %{trips: trips}) do
    %{data: render_many(trips, Trav.TripView, "trip.json")}
  end

  def render("show.json", %{trip: trip}) do
    %{data: render_one(trip, Trav.TripView, "trip.json")}
  end

  def render("trip.json", %{trip: trip}) do
    %{
      id: trip.id,
      title: trip.title,
      user_id: trip.user_id,
      plan: render_one(trip.plan, Trav.PlanView, "plan.json")
    }
  end
end
