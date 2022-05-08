defmodule SandboxWeb.AccountsControllerTest do
  use SandboxWeb.ConnCase
  @user_id "2hyfy376s5y973tt42syy"

  describe "GET /accounts" do
    test "error: Unauthorized message if not token provided", %{conn: conn} do
      conn = get(conn, "/accounts")

      assert body = json_response(conn, 401)

      %{"message" => message} = body
      assert message == "Unauthorized"
    end

    test "success: Return accounts resouse", %{conn: conn} do
      conn =
        conn
        |> auth_header(@user_id)
        |> get("/accounts")

      assert body = json_response(conn, 200)
    end
  end

  describe "GET /accounts/:id" do
    test "error:wrong id return error 404", %{conn: conn} do
      conn =
        conn
        |> auth_header(@user_id)
        |> get("/accounts/acc_123")

      assert body = json_response(conn, 401)
      %{"errors" => %{"detail" => detail}} = body

      assert detail == "Resource not found for acc_123"
    end

    test "success:account, returns user account", %{conn: conn} do
      conn =
        conn
        |> auth_header(@user_id)
        |> get("/accounts/acc_#{@user_id}")

      assert body = json_response(conn, 200)
      %{"data" => %{"id" => id}} = body

      {:ok, %{account_id: account_id}} = Sandbox.Queries.get!(:details, id)

      assert account_id == id
    end
  end

  describe "GET /accounts/:id/details" do
    test "error:wrong id returns error 404", %{conn: conn} do
      conn =
        conn
        |> auth_header(@user_id)
        |> get("/accounts/acc_123/details")

      assert body = json_response(conn, 401)
      %{"errors" => %{"detail" => detail}} = body

      assert detail == "Resource not found for acc_123"
    end

    test "success:data, returns account bank details", %{conn: conn} do
      conn =
        conn
        |> auth_header(@user_id)
        |> get("/accounts/acc_#{@user_id}/details")

      assert body = json_response(conn, 200)

      %{"account_id" => account_id} = body

      {:ok, %{account_id: id}} = Sandbox.Queries.get!(:details, account_id)

      assert account_id == id
    end
  end

  describe "GET /accounts/:id/balances" do
    test "error:404 resouce not found", %{conn: conn} do
      conn =
        conn
        |> auth_header(@user_id)
        |> get("/accounts/acc_123/balances")

      assert body = json_response(conn, 401)
      %{"errors" => %{"detail" => detail}} = body

      assert detail == "Resource not found for acc_123"
    end

    test "success:200 return account balances details", %{conn: conn} do
      conn =
        conn
        |> auth_header(@user_id)
        |> get("/accounts/acc_#{@user_id}/balances")

      assert body = json_response(conn, 200)

      %{"account_id" => account_id} = body

      {:ok, %{account_id: id}} = Sandbox.Queries.get!(:balances, account_id)

      assert account_id == id
    end
  end
end
