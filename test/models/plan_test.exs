defmodule Trav.PlanTest do
  use Trav.ModelCase

  alias Trav.{Plan, PlanFactory}

  setup do
    plan = PlanFactory.build(:plan)

    {:ok, plan: plan}
  end

  test "changeset with valid attributes", %{plan: plan} do
    changeset = Plan.changeset(plan)
    assert changeset.valid?
  end

  test "body can't be blank", %{plan: plan} do
    changeset = Plan.changeset(plan, %{body: ""})
    refute changeset.valid?
  end
end
