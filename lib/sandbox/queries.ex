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

    account
  end
end
