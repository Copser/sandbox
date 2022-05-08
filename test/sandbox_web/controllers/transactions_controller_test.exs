defmodule SandboxWeb.TransactionsControllerTest do
  use SandboxWeb.ConnCase
  @user_id "2hyfy376s5y973tt42syy"

  describe "GET /accounts/:id/transactions" do
    test "error:404, wrong id return error message", %{conn: conn} do
      conn =
        conn
        |> auth_header(@user_id)
        |> get("/accounts/acc_123/transactions")

      assert body = json_response(conn, 401)
      %{"errors" => %{"detail" => detail}} = body

      assert detail == "Resource not found for acc_123"
    end

    test "success:200, return list of account transactions", %{conn: conn} do
      conn =
        conn
        |> auth_header(@user_id)
        |> get("/accounts/acc_#{@user_id}/transactions")

      assert body = json_response(conn, 200)
    end
  end
end
