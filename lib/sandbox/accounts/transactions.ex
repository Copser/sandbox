defmodule Sandbox.Accounts.Transactions do
  @moduledoc """
    User Transactions mapping module. Provide struct
  """
  defstruct [
    account_id: "",
    amount: "",
    date: "",
    description: "",
    details: %{
      category: "",
      counterparty: %{
        name: "",
        type: ""
      },
      processing_status: "",
    },
    id: "",
    links: %{
      account: "",
      self: "",
    },
    running_balance: "",
    status: "",
    type: ""
  ]
end
