defmodule Trav.JWT do
  import Joken

  def decode(jwt) do
    jwt
    |> token
    |> with_signer(signer)
    |> verify
  end

  def encode(%Trav.User{id: user_id}) do
    encode(%{user_id: user_id})
  end

  def encode(params) do
    params
    |> token
    |> with_signer(signer)
    |> sign
    |> get_compact
  end

  defp signer do
    Application.get_env(:trav, Trav.Endpoint)
    |> Keyword.get(:secret_key_base)
    |> hs256
  end
end
