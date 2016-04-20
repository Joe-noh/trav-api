defmodule Trav.Mocks.AuthRouter do
  use Plug.Router
  import Phoenix.Controller, only: [json: 2]
  alias Trav.JWT

  plug :match
  plug :dispatch

  get "/twitter" do
    url = "https://twitter.com"

    json(conn, %{url: url})
  end

  post "/twitter/signin" do
    params_satisfied = ~w[oauth_token oauth_verifier]
      |> Enum.all?(& Map.has_key?(conn.body_params, &1))

    if params_satisfied do
      user = %{id: 1, name: "Joe_noh"} |> IO.inspect

      json(conn, %{token: JWT.encode(user)})
    else
      conn
      |> put_status(:internal_server_error)
      |> json(%{errors: %{reason: "Something went wrong"}})
    end
  end
end
