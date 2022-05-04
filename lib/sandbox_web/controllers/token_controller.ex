defmodule SandboxWeb.TokenController do
  use SandboxWeb, :controller

  def index(conn, _) do
    tokens = Sandbox.Queries.list_tokens(:tokens)

    render(conn, "index.json", tokens: tokens)
  end
end
