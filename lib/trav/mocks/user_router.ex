defmodule Trav.Mocks.UserRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp conn, 200, Poison.encode!(%{
      data: [
        %{
          user: %{
            id: 1,
            name: "Joe_noh"
          }
        },
        %{
          user: %{
            id: 2,
            name: "John_doe"
          }
        }
      ]
    })
  end

  get "/:id" do
    send_resp conn, 200, Poison.encode!(%{
      data: %{
        user: %{
          id: id,
          name: "Joe_noh"
        }
      }
    })
  end
end
