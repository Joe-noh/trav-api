defmodule Trav.MapView do
  use Trav.Web, :view

  def render("index.json", %{maps: maps}) do
    %{maps: render_many(maps, Trav.MapView, "map.json")}
  end

  def render("show.json", %{map: map}) do
    %{map: render_one(map, Trav.MapView, "map.json")}
  end

  def render("map.json", %{map: map}) do
    %{
      id: map.id,
      trip_id: map.trip_id
    }
  end
end
