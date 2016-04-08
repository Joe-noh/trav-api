defmodule Trav.CollaboratorController do
  use Trav.Web, :controller

  alias Trav.{User, Collaboration}

  plug :scrub_params, "collaborator_id" when action in [:create]

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
end
