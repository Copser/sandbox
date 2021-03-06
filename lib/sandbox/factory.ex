defmodule Sandbox.Factory do
  @moduledoc """
  Factory module provides, generic functions to populate ETS tables.
  """
  require Logger
  use Timex
  alias Sandbox.Helpers
  alias Sandbox.Accounts.BankAccounts
  alias Sandbox.Accounts.Details
  alias Sandbox.Accounts.Balances
  alias Sandbox.Category

  @base_url "http://localhost:4000"

  @users [
    %{
      account_number: "225948002075",
      deposit: 100000,
      id: "2hyfy376s5y973tt42syy",
      username: "My Checking"
    },
    %{
      account_number: "953702733078",
      deposit: 100000,
      id: "h9yhf87ta12j59742y1s9",
      username: "Jimmy Carter"
    },
    %{
      account_number: "419715297556",
      deposit: 100000,
      id: "9s8f94961ty58088f43ta",
      username: "Ronald Reagan"
    },
    %{
      account_number: "280477291653",
      deposit: 100000,
      id: "9y7951a2f14h7y0f47617",
      username: "George H. W. Bush"
    },
    %{
      account_number: "366968344337",
      deposit: 100000,
      id: "f5f3f6y7t8s7a5htj78ty",
      username: "Bill Clinton"
    },
    %{
      account_number: "953127680237",
      deposit: 100000,
      id: "y2y328t1tsy4315aa0y0t",
      username: "George W. Bush"
    },
    %{
      account_number: "469496713522",
      deposit: 100000,
      id: "2y7f1jyhh967839ys87t4",
      username: "Barack Obama"
    },
    %{
      account_number: "108585185732",
      deposit: 100000,
      id: "jhf44y8247syy8jt355f7",
      username: "Donald Trump"
    }
  ]

  @account_names [
    "My Checking", "Jimmy Carter", "Ronald Reagan", "George H. W. Bush",
    "Bill Clinton", "George W. Bush", "Barack Obama", "Donald Trump"
  ]

  @processing_status ["pending", "complete"]

  @institutions ["Chase", "Bank of America", "Wells Fargo", "Citibank", "Capital One"]

  @categories [
    "accommodation", "advertising", "bar", "charity", "clothing", "dining", "education",
    "electronics", "entertainment", "fuel", "general", "groceries", "health", "home", "income",
    "insurance","investment", "loan", "office", "phone", "service", "shopping", "software",
    "sport", "tax", "transport", "transportation", "utilities"
  ]

  @merchants [
    "Uber", "Uber Eats", "Lyft", "Five Guys", "In-N-Out Burger", "Chick-Fil-A",
    "Apple", "Amazon", "Walmart", "Target", "Hotel Tonight", "Misson Ceviche",
    "Caltrain", "Wingstop", "Slim Chickens", "CVS", "Duane Reade", "Walgreens",
    "McDonald's", "Burger King", "KFC", "Popeye's", "Shake Shack", "Lowe's",
    "Costco", "Kroger", "iTunes", "Spotify", "Best Buy", "TJ Maxx", "Aldi",
    "Macy's", "H.E. Butt", "Dollar Tree", "Verizon Wireless", "Sprint PCS",
    "Starbucks", "7-Eleven", "AT&T Wireless", "Rite Aid", "Nordstrom", "Ross",
    "Bed, Bath & Beyond", "J.C. Penney", "Subway", "O'Reilly", "Wendy's", "T-Mobile",
    "Petsmart", "Dick's Sporting Goods", "Sears", "Staples", "Domino's Pizza",
    "Papa John's", "IKEA", "Office Depot", "Foot Locker", "Lids", "GameStop",
    "Panera", "Williams-Sonoma", "Saks Fifth Avenue", "Chipotle Mexican Grill",
    "Neiman Marcus", "Jack In The Box", "Sonic", "Shell",
  ]

  @doc """
  Generate and populates :tokens ets schema.
  """
  def generate_tokens(:user) do
    user =
      @users
      |> Enum.take(1)

    for n <- user do
      token = Base.encode64("#{n.id}")

      %{id: n.id, username: n.username, token: "test_#{token}"}
    end
  end

  @doc """
  Generete users that will be used for :details, :balance, and :transaction ETS table schemas.
  """
  def create_account(:user) do
    for n <- @users do
      %{
        id: n.id,
        username: n.username,
        account_number: n.account_number,
        deposit: n.deposit,
      }
    end
  end

  @doc """
  Generate and populates :accounts ets schema
  """
  def create_bank_account(:account, user) do
    user
    |> Enum.map(fn t ->
      %BankAccounts{
        currency: "USD",
        enrollment_id: "enr_#{Helpers.generate_id}",
        id: "acc_#{t.id}",
        institution: Enum.random(__MODULE__.create_institution(:account)),
        last_four: Helpers.get_last_hour(t.account_number),
        links: %{
          balances: "#{@base_url}/accounts/acc_#{t.id}/balances",
          details: "#{@base_url}/accounts/acc_#{t.id}/details",
          self: "#{@base_url}/accounts/acc_#{t.id}",
          transactions: "#{@base_url}/accounts/acc_#{t.id}/transactions",
        },
        name: t.username,
        subtype: "checking",
        type: "depository"
      }
    end)
  end

  @doc """
  Generates and populates :details ets schema
  """
  def create_details(:account, user) do
    user
    |> Enum.map(fn t ->
      %Details{
        id: "acc_#{t.id}",
        account_id: "acc_#{t.id}",
        account_number: t.account_number,
        links: %{
          account: "#{@base_url}/accounts/acc_#{t.id}",
          self: "#{@base_url}/accounts/acc_#{t.id}/details",
        },
        routing_numbers: %{
          ach: Helpers.generate_number(9),
        }
      }
    end)
  end

  @doc """
  Generates and populates :balances ets schema
  """
  def create_balances(:account, user) do
    user
    |> Enum.map(fn t ->
      %Balances{
        id: "acc_#{t.id}",
        account_id: "acc_#{t.id}",
        available: t.deposit,
        ledger: t.deposit,
        links: %{
          account: "#{@base_url}/accounts/acc_#{t.id}",
          self: "#{@base_url}/accounts/acc_#{t.id}/balances",
        },
      }
    end)
  end


  @doc """
  Generated transaction data for :transactions resource. Data is generated for 90 days time period.
  """
  def create_transactions(:account, user) do
    interval = Helpers.generate_time_interval()

    for i <- interval do
      transaction =
        user
        |> Enum.map(fn t -> %{
          account_id: "acc_#{t.id}",
          date: i,
          description: "",
          details: Enum.random(__MODULE__.build_merchant(:merchant)),
          running_balance: 0,
          type: "card_payment"
        } end)

      Enum.map(0..5, fn _ ->
        transaction
        |> Enum.map(fn t ->
          %{
            account_id: t.account_id,
            amount: Helpers.generate_number(3) |> String.to_integer,
            date: i,
            description: __MODULE__.get_merchant_name(t.details),
            details: t.details |> Map.get(:details),
            id: __MODULE__.generate_transaction_id() |> Map.get(:id),
            links: %{
              account: "#{@base_url}/accounts/#{t.account_id}",
              self: "#{@base_url}/accounts/#{t.account_id}/transactions/#{__MODULE__.generate_transaction_id() |> Map.get(:id)}",
            },
            running_balance: t.running_balance,
            status: __MODULE__.check_status?(t.details),
            type: t.type,
          }
        end)
      end)
      |> List.flatten()
    end
    |> List.flatten()
  end

  @doc """
  Create insitution data for :account resource.

  * `id` - snake case of accounts name

  ## Example:
      iex()> Factory.create_institution(:account)
      [%{id: "chase", name: "Chase"},
      %{id: "bank_of_america", name: "Bank of America"},
      %{id: "wells_fargo", name: "Wells Fargo"},
      %{id: "citibank", name: "Citibank"},
      %{id: "capital_one", name: "Capital One"}]
  """
  def create_institution(:account) do
    for t <- @institutions do
      %{
        id: Helpers.snake_case(t),
        name: t
      }
    end
  end

  @doc """
    Build merchant data for :transaction schema

    ## Example:
      iex()> Factory.build_merchant(:merchant)

      [ ....,
        %{
          details: %{
            category: "service",
            counterparty: %{name: "BED, BATH & BEYOND", type: "organization"},
            processing_status: "complete"
          }
        },
        ....,
      ]
  """
  def build_merchant(:merchant) do
    for m <- @merchants do
      %{
        details: %{
          category: Category.category(m),
          counterparty: %{
            name: m |> String.upcase(),
            type: "organization"
          },
          processing_status: Enum.random(@processing_status),
        },
      }
    end
  end

  @doc """
  Generate transaction id for :transactions ets schema

  ## Example

    iex(20)> Factory.generate_transaction_id
    %{id: "txn_8hj0ss6yy2s83859a7h23"}
  """
  def generate_transaction_id do
    id = Helpers.generate_id

    %{id: "txn_#{id}"}
  end

  @doc """
  Extract merchange name and uppercase it.

  This function is used so mechantes names are consitent inside `:transactions` schema.
  This is used for `:transactions` `description` param.
  """
  def get_merchant_name(merchant) do
    %{details: %{counterparty: %{name: name}}} = merchant
    name = name |> String.downcase()

    with <<first::utf8, rest::binary>> <- name, do: String.upcase(<<first::utf8>>) <> rest
  end

  def subtract_ammount(ammount, deposit) do
    ammount =
      ammount
      |> String.to_integer()

    subtract = deposit - ammount

    subtract
  end

  @doc """
  Check `merchants` - `processing_status`, and assign proper payment status to transaction
  """
  def check_status?(details) do
    %{details: %{processing_status: processing_status}} = details

    cond do
      processing_status == "pending" ->
        "pending"
      processing_status == "complete" ->
        "posted"
    end
  end

  # Helper functions
  def merchants, do: @merchants
  def catgories, do: @categories
end
