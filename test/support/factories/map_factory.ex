defmodule Trav.MapFactory do
  use ExMachina.Ecto, repo: Trav.Repo

  alias Trav.Map

  def factory(:map) do
    %Map{}
  end
end
