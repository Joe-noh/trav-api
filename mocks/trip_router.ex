defmodule Trav.Mocks.TripRouter do
  use Plug.Router
  import Phoenix.Controller, only: [render: 4]

  plug :match
  plug :dispatch

  get "/" do
    trips = [
      %{
        id: 1, title: "静岡旅行", user_id: 1,
        plan: %{id: 1, body: "こんな予定です", trip_id: 1},
        map: %{id: 1, trip_id: 1}
      },
      %{
        id: 2, title: "アフリカ旅行", user_id: 1,
        plan: %{id: 2, body: "10日間だー！", trip_id: 2},
        map: %{id: 2, trip_id: 2}
      }
    ]

    render(conn, Trav.TripView, "index.json", trips: trips)
  end

  get "/:id" do
    id = String.to_integer(id)
    trip = %{
      id: id, title: "静岡旅行", user_id: 1,
      plan: %{id: 1, body: "こんな予定です", trip_id: id},
      map: %{id: 1, trip_id: id}
    }

    render(conn, Trav.TripView, "show.json", trip: trip)
  end

  post "/" do
    params = conn.body_params |> Map.get("trip")

    trip = %{
      id: 3, title: params["title"], user_id: 1,
      plan: %{id: 3, body: "", trip_id: 3},
      map: %{id: 3, trip_id: 3}
    }

    render(conn, Trav.TripView, "show.json", trip: trip)
  end

  put "/:id" do
    id = String.to_integer(id)
    params = conn.body_params |> Map.get("trip")

    trip = %{
      id: id, title: params["title"], user_id: 1,
      plan: %{id: 4, body: "", trip_id: id},
      map: %{id: 4, trip_id: id}
    }

    render(conn, Trav.TripView, "show.json", trip: trip)
  end

  delete "/:_id" do
    send_resp(conn, :no_content, "")
  end
end
