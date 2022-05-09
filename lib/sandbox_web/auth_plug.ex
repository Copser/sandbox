defmodule SandboxWeb.AuthPlug do
  @moduledoc """
  AuthPlug module that holds Basic Authentication verification logic.
  """
  @behaviour Plug
  import Plug.Conn

  alias Sandbox.Ets

  def init(opts), do: opts

  def call(conn, _) do
    header_content = Plug.Conn.get_req_header(conn, "authorization")
    respond(conn, header_content)
  end

  def respond(conn, ["Basic" <> token]) do
    token =
      token
      |> String.split("_")
      |> List.last()

    case Base.decode64(token) do
      {:ok, token} ->
        check_token(conn, token)

      _ ->
        send_unauthorised_response(conn)
    end
  end

  def respond(conn, _) do
    send_unauthorised_response(conn)
  end

  defp check_token(conn, token) do
    user = Ets.get(:tokens, token)

    user =
      user
      |> Sandbox.Helpers.tuple_to_list()
      |> List.first()

    if user do
      conn
    else
      send_unauthorised_response(conn)
    end
  end

  defp send_unauthorised_response(conn) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(401, ~s[{"message": "Unauthorized"}])
    |> halt()
  end
end
