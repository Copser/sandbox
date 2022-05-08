defmodule SandboxWeb.TransactionsView do
  use SandboxWeb, :view

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, __MODULE__, "transactions.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, __MODULE__, "transactions.json")}
  end

  def render("transactions.json", %{transactions: transactions}) do
    %{
      account_id: transactions.account_id,
      amount: transactions.amount,
      date: transactions.date,
      description: transactions.description,
      details: transactions.details,
      id: transactions.id,
      links: transactions.links,
      running_balance: transactions.running_balance,
      status: transactions.status,
      type: transactions.type,
    }
  end
end
