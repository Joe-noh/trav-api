defmodule Trav.Trip do
  use Trav.Web, :model

  alias Trav.{User, Trip, Plan, Map, Collaboration}
  alias Ecto.Multi

  schema "trips" do
    field :title, :string

    belongs_to :user, User
    has_one :plan, Plan, on_delete: :delete_all
    has_one :map,  Map,  on_delete: :delete_all
    many_to_many :collaborators, User, join_through: Collaboration,
      on_delete: :delete_all,
      on_replace: :delete

    timestamps
  end

  @allowed ~w(title)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required(:title)
    |> foreign_key_constraint(:user_id)
  end

  def build_multi(user, params) do
    trip = user
      |> build_assoc(:trips)
      |> Trip.changeset(params)
      |> put_assoc(:plan, %Plan{})
      |> put_assoc(:map,  %Map{})

    Multi.new |> Multi.insert(:trip, trip)
  end
end
