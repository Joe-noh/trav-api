defmodule Trav.AuthController do
  use Trav.Web, :controller

  def request(conn, %{"provider" => "twitter"}) do
    token = Application.get_env(:trav, :config)
      |> Keyword.get(:twiter_callback_url)
      |> ExTwitter.request_token()

    case ExTwitter.authenticate_url(token.oauth_token) do
      {:ok, authenticate_url} ->
        conn
        |> put_status(:ok)
        |> json(%{data: %{url: authenticate_url}})
      {:error, why} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: %{reason: why}})
    end
  end

  def callback(conn, %{"provider" => "twitter", "oauth_token" => token, "oauth_verifier" => verifier}) do
    case ExTwitter.access_token(verifier, token) do
      {:ok, access_token} ->
        conn
        |> put_status(:ok)
        |> json(%{data: access_token})
      {:error, why} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{errors: %{reason: why}})
    end
  end
end
