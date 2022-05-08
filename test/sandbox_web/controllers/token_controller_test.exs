defmodule SandboxWeb.TokenControllerTest do
  use SandboxWeb.ConnCase

  describe "POST /tokens" do
    test "success: returns tokens resource", %{conn: conn} do
      conn = get(conn, "/tokens")

      assert body = json_response(conn, 200)
    end
  end
end
