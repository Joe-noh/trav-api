defmodule Trav.Router do
  use Trav.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Trav.Plugs.AssignAuthPlug,
      secret: Application.get_env(:trav, Trav.Endpoint) |> Keyword.get(:secret_key_base)
  end

  scope "/api", Trav do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/trips", TripController, except: [:new, :edit]
  end
end
