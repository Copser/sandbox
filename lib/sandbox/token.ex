defmodule Sandbox.Token do
  use Joken.Config

  def token_config do
    default_claims(default_exp: 30 * 24 * 60 * 60)
    |> Map.delete("iss")
    |> Map.delete("aud")
  end
end
