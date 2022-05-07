defmodule SandboxWeb.AccountsController do
  use SandboxWeb, :controller

  def index(conn, _params) do
    accounts = Sandbox.Queries.list!(:accounts)

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

  def transactions(conn, %{"id" => id, "transaction_id" => transaction_id}) do
    account = Sandbox.Queries.lookup!(:transactions, id, transaction_id)

    render(conn, "transactions.json", account: account)
  end
end
