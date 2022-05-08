defmodule SandboxWeb.TransactionsController do
  use SandboxWeb, :controller

  def list_transactions(conn, %{"id" => id}) do
    case Sandbox.Queries.list_transactions(:transactions, id) do
      {:ok, transactions} ->
        render(conn, "index.json", transactions: transactions)
      {:error, message} ->
        conn
        |> put_status(401)
        |> json(%{errors: %{detail: message}})
    end
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
