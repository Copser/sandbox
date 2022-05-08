defmodule SandboxWeb.AccountsController do
  use SandboxWeb, :controller

  def index(conn, _params) do
    accounts = Sandbox.Queries.list!(:accounts)

    render(conn, "index.json", accounts: accounts)
  end

  def show(conn, %{"id" => id}) do
    case Sandbox.Queries.get!(:accounts, id) do
      {:ok, account} ->
        render(conn, "show.json", account: account)
      {:error, message} ->
        conn
        |> put_status(401)
        |> json(%{errors: %{detail: message}})
    end
  end

  def details(conn, %{"id" => id}) do
    case Sandbox.Queries.get!(:details, id) do
      {:ok, account} ->
        render(conn, "details.json", account: account)
      {:error, message} ->
        conn
        |> put_status(401)
        |> json(%{errors: %{detail: message}})
    end
  end

  def balances(conn, %{"id" => id}) do
    case Sandbox.Queries.get!(:balances, id) do
      {:ok, account} ->
        render(conn, "balances.json", account: account)
      {:error, message} ->
        conn
        |> put_status(401)
        |> json(%{errors: %{detail: message}})
    end
  end
end
