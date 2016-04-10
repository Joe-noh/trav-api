defmodule Trav.Router do
  use Trav.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Trav.Plugs.AssignAuthPlug
  end

  scope "/api", Trav do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit, :index]
    resources "/trips", TripController, except: [:new, :edit] do
      resources "/plans", PlanController, only: [:update]
      resources "/places", PlaceController, except: [:new, :edit]
      resources "/collaborator", CollaboratorController, only: [:create, :delete]
    end
  end

  scope "/auth", Trav do
    pipe_through :api

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
