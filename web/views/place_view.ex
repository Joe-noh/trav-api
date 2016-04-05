defmodule Trav.PlaceView do
  use Trav.Web, :view

  def render("index.json", %{places: places}) do
    %{data: render_many(places, Trav.PlaceView, "place.json")}
  end

  def render("show.json", %{place: place}) do
    %{data: render_one(place, Trav.PlaceView, "place.json")}
  end

  def render("place.json", %{place: place}) do
    %{id: place.id,
      map_id: place.map_id,
      name: place.name,
      latitude: place.latitude,
      longitude: place.longitude}
  end
end
