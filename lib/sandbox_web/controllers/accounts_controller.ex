defmodule SandboxWeb.AccountsController do
  use SandboxWeb, :controller

  def index(conn, _params) do
    accounts = Sandbox.Queries.list_accounts(:accounts)

    render(conn, "index.json", accounts: accounts)
  end

  def show(conn, %{"id" => id}) do
    account = Sandbox.Queries.get!(:accounts, id)

    render(conn, "show.json", account: account)
  end

  def details(conn, %{"id" => id}) do
    account = Sandbox.Queries.get!(:details, id)

    render(conn, "details.json", account: account)
  end

  def balances(conn, %{"id" => id}) do
    account = Sandbox.Queries.get!(:balances, id)

    render(conn, "balances.json", account: account)
  end
end
