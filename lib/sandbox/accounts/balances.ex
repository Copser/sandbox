defmodule Sandbox.Accounts.Balances do
  @moduledoc """
    User Balances mapping module. Provide struct
  """
  defstruct [
    id: "",
    account_id: "",
    available: "",
    ledger: "",
    links: %{
      account: "",
      self: ""
    }
  ]
end
