defmodule Trav.Mocks.PlanRouter do
  use Plug.Router
  import Phoenix.Controller, only: [render: 4]

  plug :match
  plug :dispatch

  put "/:_id" do
    [trip_id, id] = ~r[/api/trips/(\d+)/plans/(\d+)]
      |> Regex.run(conn.request_path)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)

    params = conn.body_params |> Map.get("plan")

    plan = %{
      id: id,
      body: params["body"],
      trip_id: trip_id
    }

    render(conn, Trav.PlanView, "show.json", plan: plan)
  end
end
