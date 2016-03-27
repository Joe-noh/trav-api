defmodule Trav.PlanTest do
  use Trav.ModelCase

  alias Trav.{Plan, PlanFactory, TripFactory}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    plan = PlanFactory.build(:plan)

    {:ok, plan: plan}
  end

  test "changeset with valid attributes", %{plan: plan} do
    changeset = Plan.changeset(plan)
    assert changeset.valid?
  end

  test "default body is empty string" do
    plan = TripFactory.create(:trip) |> build_assoc(:plan) |> Repo.insert!

    assert plan.body == ""
  end
end
