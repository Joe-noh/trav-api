defmodule Trav.TripController do
  use Trav.Web, :controller

  alias Trav.Trip

  plug Trav.Plugs.CheckAuthPlug
  plug :scrub_params, "trip" when action in [:create, :update]
  plug :correct_user when action in [:show, :update, :delete]

  def index(conn, _params) do
    trips = Repo.all(from t in Trip, preload: :plan)
    render(conn, "index.json", trips: trips)
  end

  def create(conn, %{"trip" => trip_params}) do
    multi = Trip.build_multi(conn.assigns.current_user, trip_params)

    case Repo.transaction(multi) do
      {:ok, %{trip: trip}} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", trip_path(conn, :show, trip))
        |> render("show.json", trip: Repo.preload(trip, :plan))
      {:error, _, failed_changeset, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Trav.ChangesetView, "error.json", changeset: failed_changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Trip, id) do
      nil  -> not_found(conn)
      trip -> render(conn, "show.json", trip: Repo.preload(trip, :plan))
    end
  end

  def update(conn, %{"id" => id, "trip" => trip_params}) do
    trip = Repo.get!(Trip, id)
    changeset = Trip.changeset(trip, trip_params)

    case Repo.update(changeset) do
      {:ok, trip} ->
        render(conn, "show.json", trip: Repo.preload(trip, :plan))
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

  defp correct_user(conn, _opts) do
    trip_id = conn.params |> Map.get("id") |> String.to_integer
    trip = Repo.one(from t in Trip, where: t.id == ^trip_id, preload: :user)

    case trip do
      nil  -> unauthorized(conn)
      trip -> do_correct_user(conn, trip)
    end
  end

  defp do_correct_user(conn, trip) do
    if trip.user.id == conn.assigns.current_user.id do
      conn
    else
      unauthorized(conn)
    end
  end
end
