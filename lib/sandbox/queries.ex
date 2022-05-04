defmodule Sandbox.Queries do
  alias Sandbox.Ets
  alias Sandbox.Helpers

  def list_accounts(key) do
    list = Ets.list(key)

    accounts =
      list
      |> Helpers.tuple_to_list()

    accounts
  end

  def list_tokens(key) do
    list = Ets.list(key)

    tokens =
      list
      |> Helpers.tuple_to_list()

    tokens
  end

  def get!(key, account_id) do
    account = Ets.get(key, account_id)

    account =
      account
      |> Helpers.tuple_to_list()
      |> List.first()

    account
  end
end
