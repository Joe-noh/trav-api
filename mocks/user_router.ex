defmodule Trav.Mocks.UserRouter do
  use Plug.Router
  import Phoenix.Controller, only: [render: 4]

  plug :match
  plug :dispatch

  get "/" do
    users = [
      %{id: 1, name: "Joe_noh"},
      %{id: 2, name: "John_doe"}
    ]

    render(conn, Trav.UserView, "index.json", users: users)
  end

  get "/:id" do
    user = %{
      id: id,
      name: "Joe_noh"
    }

    render(conn, Trav.UserView, "show.json", user: user)
  end

  put "/:id" do
    params = conn.body_params |> Map.get("user_params")

    user = %{
      id: id,
      name: params["name"]
    }

    render(conn, Trav.UserView, "show.json", user: user)
  end

  delete "/:_id" do
    send_resp(conn, :no_content, "")
  end
end
