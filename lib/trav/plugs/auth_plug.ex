defmodule Trav.Plugs.AuthPlug do
  import Plug.Conn

  alias Trav.{User, Repo}

  def init(secret: secret), do: secret

  def call(conn, secret) do
    case get_req_header(conn, "authorization") do
      nil -> assign(conn, :current_user, nil)
      [token] -> assign_user(conn, token, secret)
    end
  end

  defp assign_user(conn, "Bearer " <> token, secret) do
    token = Joken.token(token)
      |> Joken.with_signer(Joken.hs256 secret)
      |> Joken.verify

    case token.error do
      nil ->
        %{"user_id" => user_id} = token.claims
        assign(conn, :current_user, Repo.get(User, user_id))
      _ ->
        assign(conn, :current_user, nil)
    end
  end
end
