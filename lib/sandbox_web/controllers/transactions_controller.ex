defmodule SandboxWeb.TransactionsController do
  use SandboxWeb, :controller

  def list_transactions(conn, %{"id" => id}) do
    transactions = Sandbox.Queries.list_transactions(:transactions, id)

    render(conn, "index.json", transactions: transactions)
  end

  def transactions(conn, %{"id" => id, "transaction_id" => transaction_id}) do
    account = Sandbox.Queries.lookup!(:transactions, id, transaction_id)

    render(conn, "show.json", account: account)
  end
end
