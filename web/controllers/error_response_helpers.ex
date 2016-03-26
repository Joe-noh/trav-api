defmodule Trav.ErrorResponseHelpers do
  import Plug.Conn

  def unauthorized(conn),   do: render_error(conn, 401)
  def not_found(conn),      do: render_error(conn, 404)
  def internal_error(conn), do: render_error(conn, 500)

  defp render_error(conn, code) when is_integer(code) do
    conn |> put_status(code) |> Phoenix.Controller.render(Trav.ErrorView, "#{code}.json") |> halt
  end
end
