defmodule SandboxWeb.AccountsView do
  use SandboxWeb, :view

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, __MODULE__, "accounts.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, __MODULE__, "accounts.json")}
  end

  def render("detail.json", %{account: account}) do
    %{data: render_one(account, __MODULE__, "details.json")}
  end

  def render("balance.json", %{account: account}) do
    %{data: render_one(account, __MODULE__, "balances.json")}
  end

  def render("transaction.json", %{account: account}) do
    %{data: render_one(account, __MODULE__, "transaction.json")}
  end

  def render("accounts.json", %{accounts: accounts}) do
    %{
      currency: accounts.currency,
      enrollment_id: accounts.enrollment_id,
      id: accounts.id,
      institution: accounts.institution,
      last_four: accounts.last_four,
      links: accounts.links,
      name: accounts.name,
      subtype: accounts.subtype,
      type: accounts.type,
    }
  end

  def render("details.json", %{account: account}) do
    %{
      account_id: account.account_id,
      account_number: account.account_number,
      links: account.links,
      routing_numbers: account.routing_numbers,
    }
  end

  def render("balances.json", %{account: account}) do
    %{
      account_id: account.account_id,
      available: account.available,
      ledger: account.ledger,
      links: account.links,
    }
  end

  def render("transaction.json", %{account: account}) do
    %{
      account_id: account.account_id,
      amount: account.amount,
      date: account.date,
      description: account.description,
      details: account.details,
      id: account.id,
      links: account.links,
      running_balance: account.running_balance,
      status: account.status,
      type: account.type,
    }
  end
end
