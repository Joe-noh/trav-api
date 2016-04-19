defmodule Trav.UserController do
  use Trav.Web, :controller

  alias Trav.User

  plug Trav.Plugs.CheckAuthPlug when action != :create
  plug :scrub_params, "user" when action in [:update]
  plug :correct_user when action in [:show, :update, :delete]

  def show(conn, _params) do
    render(conn, "show.json", user: conn.assigns.current_user)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Trav.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn.assigns.current_user |> Repo.delete!

    send_resp(conn, :no_content, "")
  end

  defp correct_user(conn, _opts) do
    user_id = conn.params |> Map.get("id") |> String.to_integer

    if conn.assigns.current_user.id == user_id do
      conn
    else
      conn |> unauthorized
    end
  end
end
