defmodule Trav.CollaboratorController do
  use Trav.Web, :controller

  alias Trav.{User, Trip}

  plug :scrub_params, "collaborator_id" when action in [:create]

  def create(conn, %{"trip_id" => trip_id, "collaborator_id" => user_id}) do
    user = Repo.get!(User, user_id)
    trip = Repo.get!(Trip, trip_id) |> Repo.preload(:collaborators)

    multi = Trip.add_collaborator(trip, user)

    case Repo.transaction(multi) do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> render(Trav.UserView, "show.json", user: user)
      e = {:error, _, _, _} ->
        IO.inspect e
        conn
    end
  end

  def delete(conn, %{"trip_id" => trip_id, "id" => user_id}) do
    user = Repo.get!(User, user_id)
    trip = Repo.get!(Trip, trip_id) |> Repo.preload(:collaborators)

    multi = Trip.del_collaborator(trip, user)

    case Repo.transaction(multi) do
      {:ok, _} ->
        conn |> send_resp(:no_content, "")
      e = {:error, _, _, _} ->
        IO.inspect e
        conn
    end
  end
end
