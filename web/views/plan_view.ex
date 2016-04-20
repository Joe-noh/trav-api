defmodule Trav.PlanView do
  use Trav.Web, :view

  def render("index.json", %{plans: plans}) do
    %{plans: render_many(plans, Trav.PlanView, "plan.json")}
  end

  def render("show.json", %{plan: plan}) do
    %{plan: render_one(plan, Trav.PlanView, "plan.json")}
  end

  def render("plan.json", %{plan: plan}) do
    %{
      id: plan.id,
      body: plan.body,
      trip_id: plan.trip_id
    }
  end
end
