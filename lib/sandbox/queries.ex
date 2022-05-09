defmodule Sandbox.Queries do
  @moduledoc """
  Queris module is a wrapper arround Sandbox.Ets. Queries module holds many functions
  which are used to fetch and represent data that is stored in Sandbox ETS.
  """
  alias Sandbox.Ets
  alias Sandbox.Helpers

  @doc """
  Returns all records of an ETS table schema

  ## Expected
  * `key::atom` - table name ---> `:transactions`

  # Example

    iex(44)> Queries.list!(:accounts)
      [
        %{
          currency: "USD",
          enrollment_id: "enr_a0sjas2fs994sat63184j",
          id: "acc_y2y328t1tsy4315aa0y0t",
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
        },
        %{
          currency: "USD",
          enrollment_id: "enr_84sth6asy167yf1y1hss2",
          id: "acc_9y7951a2f14h7y0f47617",
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
        }
      ]
  """
  def list!(key) do
    list = Ets.list(key)

    list =
      list
      |> Helpers.tuple_to_list()

    list
  end

  @doc """
  Returns data for given table_name and key. Returns error if `account_id` doesn't exist.

  ## Expected

  * `table_name` - :atom that represent table name ---> `:transactions`
  * `key` - that will be used to query the schema

  # Example

    iex(64)> Queries.get!(:accounts, "acc_jhf44y8247syy8jt355f7")
      {:ok,
      %{
        currency: "USD",
        enrollment_id: "enr_8f9y64t07jj1hyta6tsy0",
        id: "acc_jhf44y8247syy8jt355f7",
        institution: %{id: "capital_one", name: "Capital One"},
        last_four: "5732",
        links: %{
          balances: "http://localhost:4000/accounts/acc_jhf44y8247syy8jt355f7/balances",
          details: "http://localhost:4000/accounts/acc_jhf44y8247syy8jt355f7/details",
          self: "http://localhost:4000/accounts/acc_jhf44y8247syy8jt355f7",
          transactions: "http://localhost:4000/accounts/acc_jhf44y8247syy8jt355f7/transactions"
        },
        name: "Donald Trump",
        subtype: "checking",
        type: "depository"
      }}


    iex(65)> Queries.get!(:accounts, "acc_123")
      {:error, "Resource not found for acc_123"}
  """
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

  @doc """
  Return one data for given set of keys. This is used only for transaction resource.
  Returns error if both `account_id` and `transaction_id` are not valid.

  ### Expected

    * `key` - :atom that represent table name ---> `:transactions`
    * `account_id` - account id
    * `transaction_id` - transaction id


  ### Example

  iex(70)> Queries.lookup!(:transactions, "acc_2y7f1jyhh967839ys87t4", "txn_3f5y5a0s9068h0hf5y3f0")
      {:ok,
      [
        {"txn_3f5y5a0s9068h0hf5y3f0",
          %{
            account_id: "acc_h9yhf87ta12j59742y1s9",
            amount: 483,
            date: ~D[2022-03-13],
            description: "Amazon",
            details: %{
              category: "software",
              counterparty: %{name: "AMAZON", type: "organization"},
              processing_status: "complete"
            },
            links: %{
              account: "http://localhost:4000/accounts/acc_h9yhf87ta12j59742y1s9",
              self: "http://localhost:4000/accounts/acc_h9yhf87ta12j59742y1s9/transactions/txn_t7aty2y4a7th4h92f2jay"
            },
            running_balance: 0,
            status: "posted",
            type: "card_payment"
          }}
      ]}


    iex(73)> Queries.lookup!(:transactions, "acc_2y7f1jyhh967839ys87t4", "txn_3f")
        {:error, "Resource not found for acc_2y7f1jyhh967839ys87t4"}
  """
  def lookup!(key, account_id, transaction_id) do
    account = Ets.select(key, account_id, transaction_id)

    if Enum.count(account) != 0 do
      {:ok, account}
    else
      {:error, "Resource not found for #{account_id}"}
    end
  end

  @doc """
  Returns a List of transactions for a give `accound_id`.
  Returns empty list if `account_id` is not valid

  ### Expects
    * `key::atom` - table name ---> `:transactions`
    * `accoun_id:string` - account id

  ### Example

  iex(76)> Queries.list_transactions(:transactions, "acc_2y7f1jyhh967839ys87t4")
    [
      %{
        account_id: "acc_2y7f1jyhh967839ys87t4",
        amount: 125,
        date: ~D[2022-05-09],
        description: "Popeye's",
        details: %{
          category: "dining",
          counterparty: %{name: "POPEYE'S", type: "organization"},
          processing_status: "complete"
        },
        id: "txn_8t41h1t0s60185sysa70y",
        links: %{
          account: "http://localhost:4000/accounts/acc_2y7f1jyhh967839ys87t4",
          self: "http://localhost:4000/accounts/acc_2y7f1jyhh967839ys87t4/transactions/txn_t353hj67y1a33t15ss8f0"
        },
        running_balance: 0,
        status: "posted",
        type: "card_payment"
      },
      %{
        account_id: "acc_2y7f1jyhh967839ys87t4",
        amount: 513,
        date: ~D[2022-05-09],
        description: "Popeye's",
        details: %{
          category: "dining",
          counterparty: %{name: "POPEYE'S", type: "organization"},
          processing_status: "complete"
        },
        id: "txn_5hythtfa71t20a7t3j188",
        links: %{
          account: "http://localhost:4000/accounts/acc_2y7f1jyhh967839ys87t4",
          self: "http://localhost:4000/accounts/acc_2y7f1jyhh967839ys87t4/transactions/txn_2y531s0f9y29f0y4ty6fy"
        }
      ]


    iex(77)> Queries.list_transactions(:transactions, "acc_2y")
      []
  """
  def list_transactions(key, account_id) do
    Ets.map_select(key, account_id)
    |> Helpers.tuple_to_list()
    |> Enum.sort_by(&(&1.date), {:desc, Date})
  end

  @doc """
  Naive implementation of Transaction pagination controls. Returns empty list if account_id or from_id (transaction_id) is not valid.

  ### Expects

    * `count::integer` - Ability to limit the maximum number of transactions returned in the API response
    * `from_id::string` - transaction from where to start the page

  ### Example

    iex(78)> Queries.filter_transactions(:transactions, "acc_2y7f1jyhh967839ys87t4", "txn_tys4yt681a4j039ft8f8y", 3)
      [
        %{
          account_id: "acc_2y7f1jyhh967839ys87t4",
          amount: 125,
          date: ~D[2022-05-09],
          description: "Popeye's",
          details: %{
            category: "dining",
            counterparty: %{name: "POPEYE'S", type: "organization"},
            processing_status: "complete"
          },
          id: "txn_8t41h1t0s60185sysa70y",
          links: %{
            account: "http://localhost:4000/accounts/acc_2y7f1jyhh967839ys87t4",
            self: "http://localhost:4000/accounts/acc_2y7f1jyhh967839ys87t4/transactions/txn_t353hj67y1a33t15ss8f0"
          },
          running_balance: 0,
          status: "posted",
          type: "card_payment"
        },
        %{
          account_id: "acc_2y7f1jyhh967839ys87t4",
          amount: 513,
          date: ~D[2022-05-09],
          description: "Popeye's",
          details: %{
            category: "dining",
            counterparty: %{name: "POPEYE'S", type: "organization"},
            processing_status: "complete"
          },
          id: "txn_5hythtfa71t20a7t3j188",
          links: %{
            account: "http://localhost:4000/accounts/acc_2y7f1jyhh967839ys87t4",
            self: "http://localhost:4000/accounts/acc_2y7f1jyhh967839ys87t4/transactions/txn_2y531s0f9y29f0y4ty6fy"
          },
          running_balance: 0,
          status: "posted",
          type: "card_payment"
        },
        %{
          account_id: "acc_2y7f1jyhh967839ys87t4",
          amount: 854,
          date: ~D[2022-05-09],
          description: "Popeye's",
          details: %{
            category: "dining",
            counterparty: %{name: "POPEYE'S", type: "organization"},
            processing_status: "complete"
          },
          id: "txn_82y1h887t32fy8tyt3950",
          links: %{
            account: "http://localhost:4000/accounts/acc_2y7f1jyhh967839ys87t4",
            self: "http://localhost:4000/accounts/acc_2y7f1jyhh967839ys87t4/transactions/txn_59092yt7h97s198294yay"
          },
          running_balance: 0,
          status: "posted",
          type: "card_payment"
        }
      ]


    iex(79)> Queries.filter_transactions(:transactions, "acc_2y7", "txn_tys4yt681a4j039ft8f8y", 3)
        []
  """
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
