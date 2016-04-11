defmodule Trav.AuthControllerTest do
  use Trav.ConnCase, async: true
  import Mock

  alias Trav.{User, JWT}

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.checkout(Trav.Repo)

    {:ok, %{conn: conn}}
  end

  test "GET request", %{conn: conn} do
    token = "Z6eEdO8MOmk394WozF5oKyuAv855l4Mlqo7hhlSLik"
    url   = "https://api.twitter.com/oauth/authenticate?oauth_token=#{token}"

    with_mock ExTwitter, [
      request_token:    fn _url -> %{oauth_token: token} end,
      authenticate_url: fn ^token -> {:ok, url} end
    ] do
      response = conn
        |> get(auth_path(conn, :request, "twitter"))
        |> json_response(200)

      assert response["data"]["url"] == url
    end
  end

  test "POST signin", %{conn: conn} do
    token    = "NPcudxy0yU5T3tBzho7iCotZ3cnetKwcTIRlX0iwRl0"
    verifier = "uw7NjWHT6OJ1MpJOXsHfNxoAhPKpgI8BlYDhxEjIBY"
    oauth_token        = "7588892-kagSNqWge8gB1WwE3plnFsJHAZVfxWD7Vb57p0b4"
    oauth_token_secret = "PbKfYqSryyeKDWz4ebtY3o5ogNLG11WJuZBc9fQrQo"
    user_name = "Joe_noh"

    map = %{
      oauth_token: oauth_token,
      oauth_token_secret: oauth_token_secret,
      screen_name: user_name
    }
    with_mock ExTwitter, [
      access_token: fn (^verifier, ^token) -> {:ok, map} end
    ] do
      assert Repo.get_by(User, name: user_name) == nil

      response = conn
        |> post(auth_path(conn, :signin, "twitter"), oauth_token: token, oauth_verifier: verifier)
        |> json_response(201)

      assert response["data"]["token"]

      user = Repo.get_by(User, name: user_name)

      response = conn
        |> post(auth_path(conn, :signin, "twitter"), oauth_token: token, oauth_verifier: verifier)
        |> json_response(201)

      token = response["data"]["token"] |> JWT.decode
      assert token.claims |> Map.get("user_id") == user.id
    end
  end
end
