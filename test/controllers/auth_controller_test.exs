defmodule Trav.AuthControllerTest do
  use Trav.ConnCase, async: true
  import Mock

  setup %{conn: conn} do
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

  test "GET callback", %{conn: conn} do
    token    = "NPcudxy0yU5T3tBzho7iCotZ3cnetKwcTIRlX0iwRl0"
    verifier = "uw7NjWHT6OJ1MpJOXsHfNxoAhPKpgI8BlYDhxEjIBY"
    oauth_token        = "7588892-kagSNqWge8gB1WwE3plnFsJHAZVfxWD7Vb57p0b4"
    oauth_token_secret = "PbKfYqSryyeKDWz4ebtY3o5ogNLG11WJuZBc9fQrQo"

    map = %{oauth_token: oauth_token, oauth_token_secret: oauth_token_secret}
    with_mock ExTwitter, [
      access_token: fn (^verifier, ^token) -> {:ok, map} end
    ] do
      response = conn
        |> get(auth_path(conn, :callback, "twitter"), oauth_token: token, oauth_verifier: verifier)
        |> json_response(200)

      assert response["data"]["oauth_token"] == map.oauth_token
      assert response["data"]["oauth_token_secret"] == map.oauth_token_secret
    end
  end
end
