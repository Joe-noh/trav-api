defmodule Trav.Trip do
  use Trav.Web, :model

  alias Trav.User

  schema "trips" do
    field :title, :string
    belongs_to :user, User

    timestamps
  end

  @allowed ~w(title)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required(:title)
    |> assoc_constraint(:user)
  end
end
