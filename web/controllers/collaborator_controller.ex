defmodule Trav.CollaboratorController do
  use Trav.Web, :controller

  alias Trav.{User, Trip, Collaboration}

  plug Trav.Plugs.CheckAuthPlug
  plug :scrub_params, "collaborator_id" when action in [:create]
  plug :correct_user

  def create(conn, %{"trip_id" => trip_id, "collaborator_id" => collaborator_id}) do
    changeset = %Collaboration{trip_id: String.to_integer(trip_id), user_id: collaborator_id}
      |> Collaboration.changeset

    case Repo.insert(changeset) do
      {:ok, _} ->
        collaborator = Repo.get(User, collaborator_id)

        conn
        |> put_status(:created)
        |> render(Trav.UserView, "show.json", user: collaborator)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Trav.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"trip_id" => trip_id, "id" => collaborator_id}) do
    collaboration = Repo.one(
      from c in Collaboration,
      where: c.trip_id == ^trip_id and c.user_id == ^collaborator_id
    )

    if collaboration, do: Repo.delete!(collaboration)

    conn |> send_resp(:no_content, "")
  end

  defp correct_user(conn, _opts) do
    trip_id = conn.params |> Map.get("trip_id") |> String.to_integer
    trip = Repo.get!(Trip, trip_id)

    if conn.assigns.current_user.id == trip.user_id do
      conn
    else
      conn |> unauthorized
    end
  end
end
