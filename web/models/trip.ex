defmodule Trav.Trip do
  use Trav.Web, :model

  alias Trav.{User, Plan}

  schema "trips" do
    field :title, :string

    belongs_to :user, User
    has_one :plan, Plan

    timestamps
  end

  @allowed ~w(title)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required(:title)
    |> assoc_constraint(:user)
  end
end
