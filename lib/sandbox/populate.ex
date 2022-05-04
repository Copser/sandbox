defmodule Sandbox.Populate do
  require Logger
  alias Sandbox.Ets
  alias Sandbox.Helpers
  alias Sandbox.Factory

  def populate_sanbox! do
    users = Factory.create_account(:user)
    tokens = Factory.generate_tokens(:user)
    banks = Factory.create_bank_account(:account, users)
    details = Factory.create_details(:account, users)
    balances = Factory.create_balances(:account, users)

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

    auth_tokens = Ets.create_or_update_ets_table(:tokens, tokens)
    sandbox_users = Ets.create_or_update_ets_table(:users, users)
    bank_account = Ets.create_or_update_ets_table(:accounts, banks)
    account_details = Ets.create_or_update_ets_table(:details, details)
    account_balances = Ets.create_or_update_ets_table(:balances, balances)

    Logger.info("Sandbox Users created, #{sandbox_users}")
    Logger.info("Tokens Generated #{auth_tokens}")
    Logger.info("Bank Account Table created, #{bank_account}")
    Logger.info("Account Details Table created #{account_details}")
    Logger.info("Account Balances Table #{account_balances}")
  end
end
