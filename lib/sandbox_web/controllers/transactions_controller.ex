defmodule SandboxWeb.TransactionsController do
  use SandboxWeb, :controller

  def list_transactions(conn, %{"id" => id, "from_id" => from_id, "count" => count}) do
    count = count |> String.to_integer()
    transactions = Sandbox.Queries.filter_transactions(:transactions, id, from_id, count)

    render(conn, "index.json", transactions: transactions)
  end
  def list_transactions(conn, %{"id" => id}) do
    transactions = Sandbox.Queries.list_transactions(:transactions, id)

    render(conn, "index.json", transactions: transactions)
  end


  def transactions(conn, %{"id" => id, "transaction_id" => transaction_id}) do
    case Sandbox.Queries.lookup!(:transactions, id, transaction_id) do
      {:ok, account} ->
        render(conn, "show.json", account: account)
      {:error, message} ->
        conn
        |> put_status(401)
        |> json(%{errors: %{detail: message}})
    end
  end
end
