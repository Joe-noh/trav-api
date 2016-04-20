defmodule Trav.AuthController do
  use Trav.Web, :controller

  alias Trav.{User, JWT}

  def request(conn, %{"provider" => "twitter"}) do
    token = Application.get_env(:trav, :config)
      |> Keyword.get(:twitter_callback_url)
      |> ExTwitter.request_token

    case ExTwitter.authenticate_url(token.oauth_token) do
      {:ok, authenticate_url} ->
        conn
        |> put_status(:ok)
        |> json(%{url: authenticate_url})
      {:error, why} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: %{reason: why}})
    end
  end

  def signin(conn, %{"provider" => "twitter", "oauth_token" => token, "oauth_verifier" => verifier}) do
    case ExTwitter.access_token(verifier, token) do
      {:ok, access_token} ->
        user = user_from_token(access_token)

        conn
        |> put_status(:created)
        |> json(%{token: JWT.encode(user)})
      {:error, why} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: %{reason: why}})
    end
  end

  defp user_from_token(%{screen_name: screen_name}) do
    case Repo.get_by(User, name: screen_name) do
      nil  -> %User{name: screen_name} |> User.changeset() |> Repo.insert!
      user -> user
    end
  end
end
