defmodule Trav.Mocks.AppRouter do
  use Plug.Router

  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :content_type, "application/json"
  plug :match
  plug :dispatch

  forward "/api/users", to: Trav.Mocks.UserRouter

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp content_type(conn, type) do
    conn |> put_resp_content_type(type)
  end
end
