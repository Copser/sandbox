defmodule Sandbox.Populate do
  @moduledoc """
  Populate module is responsible for generating and populating data into Sandbox ETS.
  """
  use GenServer
  require Logger
  alias Sandbox.Ets
  alias Sandbox.Helpers
  alias Sandbox.Factory

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    __MODULE__.populate_sanbox!()

    {:ok, nil}
  end

  def populate_sanbox! do
    users = Factory.create_account(:user)
    tokens = Factory.generate_tokens(:user)
    banks = Factory.create_bank_account(:account, users)
    details = Factory.create_details(:account, users)
    balances = Factory.create_balances(:account, users)
    transactions = Factory.create_transactions(:account, users)

    users = Helpers.list_to_tuple(users, [
      :username,
      :account_number,
      :deposit,
    ])

    tokens = Helpers.list_to_tuple(tokens, [
      :username,
      :token,
    ])

    banks = Helpers.list_to_tuple(banks, [
      :currency,
      :enrollment_id,
      :institution,
      :last_four,
      :links,
      :name,
      :subtype,
      :type,
    ])

    details = Helpers.list_to_tuple(details, [
      :account_id,
      :account_number,
      :links,
      :routing_numbers
    ])

    balances = Helpers.list_to_tuple(balances, [
      :account_id,
      :available,
      :ledger,
      :links,
    ])

    transactions = Helpers.list_to_tuple(transactions, [
      :account_id,
      :amount,
      :date,
      :description,
      :details,
      :links,
      :running_balance,
      :status,
      :type,
    ])

    auth_tokens = Ets.create_or_update_ets_table(:tokens, tokens)
    sandbox_users = Ets.create_or_update_ets_table(:users, users)
    bank_account = Ets.create_or_update_ets_table(:accounts, banks)
    account_details = Ets.create_or_update_ets_table(:details, details)
    account_balances = Ets.create_or_update_ets_table(:balances, balances)
    account_transactions = Ets.create_or_update_ets_table(:transactions, transactions)

    Logger.info("Sandbox Users created, #{sandbox_users}")
    Logger.info("Tokens Generated #{auth_tokens}")
    Logger.info("Bank Account Table created, #{bank_account}")
    Logger.info("Account Details Table created #{account_details}")
    Logger.info("Account Balances Table #{account_balances}")
    Logger.info("Account Transactions Table created #{account_transactions}")
  end
end
