defmodule Trav.TripServiceTest do
  use ExUnit.Case

  alias Trav.Repo
  alias Trav.TripService
  alias Trav.UserFactory

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    user = UserFactory.create(:user)

    {:ok, %{user: user}}
  end

  test "build", %{user: user} do
    title = "沖縄旅行"
    body  = "行ってきます"

    {:ok, %{trip: trip, plan: plan}} = TripService.build(user, title, body) |> Repo.transaction

    assert trip.title == title
    assert plan.body  == body
  end
end
