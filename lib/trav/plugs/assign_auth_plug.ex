defmodule Trav.Plugs.AssignAuthPlug do
  import Plug.Conn

  alias Trav.{User, Repo, JWT}

  def init(secret: secret), do: secret

  def call(conn, secret) do
    case get_req_header(conn, "authorization") do
      [token] -> assign_user(conn, token, secret)
      _other  -> assign(conn, :current_user, nil)
    end
  end

  defp assign_user(conn, "Bearer " <> token, secret) do
    token = JWT.decode(token, secret)

    case token.error do
      nil ->
        %{"user_id" => user_id} = token.claims
        assign(conn, :current_user, Repo.get(User, user_id))
      _other ->
        assign(conn, :current_user, nil)
    end
  end
end
