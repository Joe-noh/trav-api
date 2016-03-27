defmodule Trav.PlaceController do
  use Trav.Web, :controller

  alias Trav.Place

  plug :scrub_params, "place" when action in [:create, :update]

  def index(conn, _params) do
    places = Repo.all(Place)
    render(conn, "index.json", places: places)
  end

  def create(conn, %{"place" => place_params}) do
    changeset = Place.changeset(%Place{}, place_params)

    case Repo.insert(changeset) do
      {:ok, place} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", trip_place_path(conn, :show, place))
        |> render("show.json", place: place)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Trav.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    place = Repo.get!(Place, id)
    render(conn, "show.json", place: place)
  end

  def update(conn, %{"id" => id, "place" => place_params}) do
    place = Repo.get!(Place, id)
    changeset = Place.changeset(place, place_params)

    case Repo.update(changeset) do
      {:ok, place} ->
        render(conn, "show.json", place: place)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Trav.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    place = Repo.get!(Place, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(place)

    send_resp(conn, :no_content, "")
  end
end
