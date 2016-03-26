defmodule Trav.PlanController do
  use Trav.Web, :controller

  alias Trav.Plan

  plug Trav.Plugs.CheckAuthPlug
  plug :scrub_params, "plan" when action in [:update]
  plug :correct_user when action in [:show, :update, :delete]

  def show(conn, %{"trip_id" => trip_id, "id" => id}) do
    plan = Repo.one!(from p in Plan, where: p.id == ^id and p.trip_id == ^trip_id)
    render(conn, "show.json", plan: plan)
  end

  def update(conn, %{"trip_id" => trip_id, "id" => id, "plan" => plan_params}) do
    plan = Repo.one!(from p in Plan, where: p.id == ^id and p.trip_id == ^trip_id)
    changeset = Plan.changeset(plan, plan_params)

    case Repo.update(changeset) do
      {:ok, plan} ->
        render(conn, "show.json", plan: plan)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Trav.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"trip_id" => trip_id, "id" => id}) do
    Repo.one!(from p in Plan, where: p.id == ^id and p.trip_id == ^trip_id) |> Repo.delete!

    send_resp(conn, :no_content, "")
  end

  defp correct_user(conn, _opts) do
    plan_id = conn.params |> Map.get("id") |> String.to_integer
    plan = Repo.one(from p in Plan, where: p.id == ^plan_id, preload: [trip: :user])

    case plan do
      nil  -> unauthorized(conn)
      plan -> do_correct_user(conn, plan)
    end
  end

  defp do_correct_user(conn, plan) do
    if conn.assigns.current_user.id == plan.trip.user.id do
      conn
    else
      conn |> unauthorized
    end
  end
end
