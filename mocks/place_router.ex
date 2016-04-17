defmodule Trav.Mocks.PlaceRouter do
  use Plug.Router
  import Phoenix.Controller, only: [render: 4]

  plug :match
  plug :dispatch

  get "/" do
    places = [
      %{
        id: 1,
        map_id: 1,
        name: "熱川バナナワニ園",
        latitude: "34.8168247",
        longitude: "139.0658421"
      },
      %{
        id: 2,
        map_id: 1,
        name: "伊豆シャボテン公園",
        latitude: "35.1789995",
        longitude: "138.3750759"
      }
    ]

    render(conn, Trav.PlaceView, "index.json", places: places)
  end

  get "/:id" do
    place = %{
      id: String.to_integer(id),
      map_id: 1,
      name: "熱川バナナワニ園",
      latitude: "34.8168247",
      longitude: "139.0658421"
    }

    render(conn, Trav.PlaceView, "show.json", place: place)
  end

  post "/" do
    params = conn.body_params |> Map.get("place")

    place = %{
      id: 3,
      map_id: 1,
      name: params["name"],
      latitude: params["latitude"],
      longitude: params["longitude"]
    }

    render(conn, Trav.PlaceView, "show.json", place: place)
  end

  put "/:id" do
    params = conn.body_params |> Map.get("place")

    place = %{
      id: String.to_integer(id),
      map_id: 1,
      name: params["name"],
      latitude: params["latitude"],
      longitude: params["longitude"]
    }

    render(conn, Trav.PlaceView, "show.json", place: place)
  end

  delete "/:_id" do
    send_resp(conn, :no_content, "")
  end
end
