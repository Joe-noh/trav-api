defmodule Trav.TripController do
  use Trav.Web, :controller

  alias Trav.Trip

  plug Trav.Plugs.CheckAuthPlug
  plug :scrub_params, "trip" when action in [:create, :update]

  def index(conn, _params) do
    trips = Repo.all(Trip)
    render(conn, "index.json", trips: trips)
  end

  def create(conn, %{"trip" => trip_params}) do
    changeset = Trip.changeset(%Trip{}, trip_params)

    case Repo.insert(changeset) do
      {:ok, trip} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", trip_path(conn, :show, trip))
        |> render("show.json", trip: trip)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Trav.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    trip = Repo.get!(Trip, id)
    render(conn, "show.json", trip: trip)
  end

  def update(conn, %{"id" => id, "trip" => trip_params}) do
    trip = Repo.get!(Trip, id)
    changeset = Trip.changeset(trip, trip_params)

    case Repo.update(changeset) do
      {:ok, trip} ->
        render(conn, "show.json", trip: trip)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Trav.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    trip = Repo.get!(Trip, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(trip)

    send_resp(conn, :no_content, "")
  end
end
