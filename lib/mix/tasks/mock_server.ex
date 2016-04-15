defmodule Mix.Tasks.MockServer do
  use Mix.Task

  @shortdoc "mock"

  def run(_) do
    {:ok, _} = Plug.Adapters.Cowboy.http Trav.Mocks.AppRouter, []
    :timer.sleep :infinity
  end
end
