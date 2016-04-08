defmodule Trav.Plan do
  use Trav.Web, :model

  schema "plans" do
    field :body, :string, default: ""

    belongs_to :trip, Trav.Trip

    timestamps
  end

  @allowed ~w(body)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> assoc_constraint(:trip)
  end
end
