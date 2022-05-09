defmodule SandboxWeb.TransactionsControllerTest do
  use SandboxWeb.ConnCase
  @user_id "2hyfy376s5y973tt42syy"
  @txn_id "txn_07t1a99s6y0t7y651sy14"

  describe "GET /accounts/:id/transactions" do
    test "error:200, wrong id return empty list", %{conn: conn} do
      conn =
        conn
        |> auth_header(@user_id)
        |> get("/accounts/acc_123/transactions")

      assert body = json_response(conn, 200)
      %{"data" => data} = body

      assert data == []
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
