defmodule Trav.JWT do
  import Joken

  def decode(jwt, secret) do
    jwt
    |> token
    |> with_signer(hs256 secret)
    |> verify
  end

  def encode(params, secret) do
    params
    |> token
    |> with_signer(hs256 secret)
    |> sign
    |> get_compact
  end
end
