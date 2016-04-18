defmodule Trav.Mocks.CollaboratorRouter do
  use Plug.Router
  import Phoenix.Controller, only: [render: 4]

  plug :match
  plug :dispatch

  post "/" do
    id = conn.body_params |> Map.get("collaborator_id")

    collaborator = %{id: id, name: "Joe_noh"}

    render(conn, Trav.UserView, "show.json", user: collaborator)
  end

  delete "/:_id" do
    send_resp(conn, :no_content, "")
  end
end
