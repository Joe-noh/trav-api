defmodule Trav.User do
  use Trav.Web, :model

  schema "users" do
    field :name, :string

    timestamps
  end

  @allowed ~w(name)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @allowed)
    |> validate_required(:name)
  end
end
