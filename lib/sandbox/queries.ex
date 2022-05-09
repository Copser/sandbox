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
    Ets.map_select(key, account_id)
    |> Helpers.tuple_to_list()
    |> Enum.sort_by(&(&1.date), {:desc, Date})
  end

  def filter_transactions(key, account_id, from_id \\ "", count \\ 0) do
    transactions =
      Ets.map_select(key, account_id)
      |> Helpers.tuple_to_list()
      |> Enum.sort_by(&(&1.date), {:desc, Date})

    transactions
    |> Enum.map(fn t ->
      if t.id == from_id do
        transactions |> Enum.take(count)
      end
    end)
    |> Enum.reject(fn x -> x == nil end)
    |> List.flatten()
  end
end
