defmodule Trav.PlanController do
  use Trav.Web, :controller

  alias Trav.{Plan, Trip}

  plug :scrub_params, "plan" when action in [:create, :update]

  def create(conn, %{"trip_id" => trip_id, "plan" => plan_params}) do
    trip = Repo.get!(Trip, trip_id)
    changeset = Plan.changeset(%Plan{}, plan_params)

    case Repo.insert(changeset) do
      {:ok, plan} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", trip_plan_path(conn, :show, trip, plan))
        |> render("show.json", plan: plan)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Trav.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    plan = Repo.get!(Plan, id)
    render(conn, "show.json", plan: plan)
  end

  def update(conn, %{"id" => id, "plan" => plan_params}) do
    plan = Repo.get!(Plan, id)
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

  def delete(conn, %{"id" => id}) do
    plan = Repo.get!(Plan, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(plan)

    send_resp(conn, :no_content, "")
  end
end
