defmodule SandboxWeb.TokenView do
  use SandboxWeb, :view

  def render("index.json", %{tokens: tokens}) do
    %{data: render_many(tokens, __MODULE__, "tokens.json")}
  end

  def render("tokens.json", %{token: token}) do
    %{
      username: token.username,
      token: token.token
    }
  end
end
