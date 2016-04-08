defmodule Trav.Collaboration do
  use Trav.Web, :model

  alias Trav.{User, Trip}

  schema "collaborations" do
    belongs_to :user, User
    belongs_to :trip, Trip

    timestamps
  end

  @allowed ~w()

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:trip_id)
    |> unique_constraint(:trip_id, name: :collaborations_trip_id_user_id_index)
  end
end
