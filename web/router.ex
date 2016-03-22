defmodule Trav.Router do
  use Trav.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Trav do
    pipe_through :api
  end
end
