defmodule Sandbox.Accounts.BankAccounts do
  @moduledoc """
    Accounts mapping module. Provide struct
  """
  defstruct [
    currency: "",
    enrollment_id: "",
    id: "",
    institution: %{
      id: "",
      name: ""
    },
    last_four: "",
    links: %{
      balances: "",
      details: "",
      self: "",
      transactions: "",
    },
    name: "",
    subtype: "",
    type: ""
  ]
end
