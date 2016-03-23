defmodule Trav.Trip do
  use Trav.Web, :model

  alias Trav.User

  schema "trips" do
    field :title, :string
    belongs_to :user, User

    timestamps
  end

  @allowed ~w(title user_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @allowed)
    |> validate_required(:title)
    |> validate_required(:user_id)
  end
end
