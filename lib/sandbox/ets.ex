defmodule Sandbox.Ets do
  @moduledoc """
  Ets module, which provide ets table creation and lookup
  """

  @doc """
  Creates or updates exising ETS table schema.

  ## Expected

  * `table_name` - :atom that represent table name ---> `:transactions`
  * `list` - list of tuple data

  ## Example
    [
      {"txn_05h0f14877a091yj7358a",
      %{
        account_id: "acc_f5f3f6y7t8s7a5htj78ty",
        amount: 289,
        date: ~D[2022-03-16],
        details: %{
          details: %{
            category: "transport",
            counterparty: %{name: "UBER", type: "organization"},
            processing_status: "complete"
          }
        },
        links: %{
          account: "http://localhost:4000/accounts/acc_f5f3f6y7t8s7a5htj78ty",
          self: "http://localhost:4000/accounts/acc_f5f3f6y7t8s7a5htj78ty/balances/transactions/txn_f5f3f6y7t8s7a5htj78ty"
        },
        running_balance: 100000,
        status: "posted",
        type: "card_payment"
      }}
    ]
  """
  def create_or_update_ets_table(table_name, list) when is_atom(table_name) do
    if Enum.member?(:ets.all(), table_name) do
      :ets.delete(table_name)
      :ets.new(table_name, [:duplicate_bag, :public, :named_table])
      Enum.each(list, fn element -> :ets.insert(table_name, element) end)
    else
      :ets.new(table_name, [:duplicate_bag, :public, :named_table])
      Enum.each(list, fn element -> :ets.insert(table_name, element) end)
    end
  end

  @doc """
  Returns data for given table_name and key.

  ## Expected

  * `table_name` - :atom that represent table name ---> `:transactions`
  * `key` - that will be used to query the schema

  # Example

    iex(39)> Ets.get(:accounts, "acc_2hyfy376s5y973tt42syy")

      [
        {"acc_2hyfy376s5y973tt42syy",
        %{
          currency: "USD",
          enrollment_id: "enr_5ty4y3y2a4hyhyy4fy9j7",
          institution: %{id: "chase", name: "Chase"},
          last_four: "2075",
          links: %{
            balances: "http://localhost:4000/accounts/acc_2hyfy376s5y973tt42syy/balances",
            details: "http://localhost:4000/accounts/acc_2hyfy376s5y973tt42syy/details",
            self: "http://localhost:4000/accounts/acc_2hyfy376s5y973tt42syy",
            transactions: "http://localhost:4000/accounts/acc_2hyfy376s5y973tt42syy/transactions"
          },
          name: "My Checking",
          subtype: "checking",
          type: "depository"
        }}
      ]
  """
  def get(table_name, key) when is_atom(table_name) and is_binary(key) do
    :ets.lookup(table_name, key)
  end

  @doc """
  Returns all records of an ETS table schema

  ## Expected
  * `table_name` - :atom that represent table name ---> `:transactions`

  # Example

    iex(44)> Ets.list(:accounts)
      [
        {"acc_y2y328t1tsy4315aa0y0t",
        %{
          currency: "USD",
          enrollment_id: "enr_a0sjas2fs994sat63184j",
          institution: %{id: "wells_fargo", name: "Wells Fargo"},
          last_four: "0237",
          links: %{
            balances: "http://localhost:4000/accounts/acc_y2y328t1tsy4315aa0y0t/balances",
            details: "http://localhost:4000/accounts/acc_y2y328t1tsy4315aa0y0t/details",
            self: "http://localhost:4000/accounts/acc_y2y328t1tsy4315aa0y0t",
            transactions: "http://localhost:4000/accounts/acc_y2y328t1tsy4315aa0y0t/transactions"
          },
          name: "George W. Bush",
          subtype: "checking",
          type: "depository"
        }},
        {"acc_9y7951a2f14h7y0f47617",
        %{
          currency: "USD",
          enrollment_id: "enr_84sth6asy167yf1y1hss2",
          institution: %{id: "chase", name: "Chase"},
          last_four: "1653",
          links: %{
            balances: "http://localhost:4000/accounts/acc_9y7951a2f14h7y0f47617/balances",
            details: "http://localhost:4000/accounts/acc_9y7951a2f14h7y0f47617/details",
            self: "http://localhost:4000/accounts/acc_9y7951a2f14h7y0f47617",
            transactions: "http://localhost:4000/accounts/acc_9y7951a2f14h7y0f47617/transactions"
          },
          name: "George H. W. Bush",
          subtype: "checking",
          type: "depository"
        }},
        .......,
      ]
  """
  def list(table_name) when is_atom(table_name) do
    :ets.tab2list(table_name)
  end


  @doc """
  Return one data for given set of keys. This is used only for transaction resource.

  ### Expected

    * `table_name` - :atom that represent table name ---> `:transactions`
    * `id` - account id
    * `tnx_id` - transaction id

  ### Example

    iex(49)> Ets.select(:transactions, "acc_2hyfy376s5y973tt42syy", "txn_863s7ta0ft757yyah5h4s")

    [
      {"txn_863s7ta0ft757yyah5h4s",
      %{
        account_id: "acc_2hyfy376s5y973tt42syy",
        amount: 285,
        date: ~D[2022-03-04],
        description: "Sears",
        details: %{
          category: "electronics",
          counterparty: %{name: "SEARS", type: "organization"},
          processing_status: "pending"
        },
        links: %{
          account: "http://localhost:4000/accounts/acc_2hyfy376s5y973tt42syy",
          self: "http://localhost:4000/accounts/acc_2hyfy376s5y973tt42syy/transactions/txn_a7f7631248h649a9s0397"
        },
        running_balance: 0,
        status: "pending",
        type: "card_payment"
      }}
    ]
  """
  def select(table_name, id, tnx_id) do
    :ets.select(table_name, [{{:"$1", :_}, [{:or, {:==, :"$1", id}, {:==, :"$1", tnx_id}}], [:"$_"]}])
  end

  @doc """
  Returns a list of transactions for a give id. This is only used for `transactions` resource

  ### Expected

    * `table_name` - :atom that represent table name ---> `:transactions`
    * `id` - account id


  ### Example

    iex(56)> Ets.map_select(:transactions, "acc_2hyfy376s5y973tt42syy")

      [
        {"txn_4612y8042yy3901yyata1",
        %{
          account_id: "acc_2hyfy376s5y973tt42syy",
          amount: 165,
          date: ~D[2022-04-27],
          description: "Subway",
          details: %{
            category: "dining",
            counterparty: %{name: "SUBWAY", type: "organization"},
            processing_status: "complete"
          },
          links: %{
            account: "http://localhost:4000/accounts/acc_2hyfy376s5y973tt42syy",
            self: "http://localhost:4000/accounts/acc_2hyfy376s5y973tt42syy/transactions/txn_ja1889as49261f278ythh"
          },
          running_balance: 0,
          status: "posted",
          type: "card_payment"
        }},
        {"txn_0fth82tjs4t97564t9890",
        %{
          account_id: "acc_2hyfy376s5y973tt42syy",
          amount: 339,
          date: ~D[2022-03-28],
          description: "Nordstrom",
          details: %{
            category: "loan",
            counterparty: %{name: "NORDSTROM", type: "organization"},
            processing_status: "complete"
          },
          links: %{
            account: "http://localhost:4000/accounts/acc_2hyfy376s5y973tt42syy",
            self: "http://localhost:4000/accounts/acc_2hyfy376s5y973tt42syy/transactions/txn_97a819a1t3ayya801t496"
          },
          running_balance: 0,
          status: "posted",
          type: "card_payment"
        }},
        .....
      ]

  """
  def map_select(table_name, id) do
    # fun = :ets.fun2ms(fn {_, map} when map.account_id == id -> map end) ## bad arg??

    :ets.select(table_name, [{{:_, :"$1"}, [{:==, {:map_get, :account_id, :"$1"}, id}], [:"$_"]}])
    # :ets.select(table_name, fun)
  end
end
