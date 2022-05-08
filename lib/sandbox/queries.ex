defmodule Sandbox.Queries do
  alias Sandbox.Ets
  alias Sandbox.Helpers

  def list!(key) do
    list = Ets.list(key)

    list =
      list
      |> Helpers.tuple_to_list()

    list
  end

  def get!(key, account_id) do
    account = Ets.get(key, account_id)

    account =
      account
      |> Helpers.tuple_to_list()
      |> List.first()

    if is_nil(account) == false do
      {:ok, account}
    else
      {:error, "Resource not found for #{account_id}"}
    end
  end

  def lookup!(key, account_id, transaction_id) do
    account = Ets.select(key, account_id, transaction_id)

    if is_nil(account) == false do
      {:ok, account}
    else
      {:error, "Resource not found for #{account_id}"}
    end
  end

  def list_transactions(key, account_id) do
    transactions = Ets.map_select(key, account_id)

    if Enum.count(transactions) == 0 do
      {:error, "Resource not found for #{account_id}"}
    else
      transactions =
        transactions
        |> Helpers.tuple_to_list()

      {:ok, transactions}
    end
  end
end
