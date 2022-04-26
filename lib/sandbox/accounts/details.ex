defmodule Sandbox.Accounts.Details do
  @moduledoc """
  Account Details mapping module. Provide struct
  """
  defstruct [
    id: "",
    account_id: "",
    account_number: "",
    links: %{
      account: "",
      self: "",
    },
    routing_numbers: %{
      ach: "",
    }
  ]
end
