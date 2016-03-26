defmodule Trav.Plugs.CheckAuthPlug do
  import Plug.Conn

  def init(_opts), do: []

  def call(conn, _opts) do
    case conn.assigns.current_user do
      nil -> conn |> send_resp(:unauthorized, "Unauthorized") |> halt
      _ -> conn
    end
  end
end
