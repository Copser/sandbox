defmodule Sandbox.Factory do
  require Logger
  use Timex
  alias Sandbox.Helpers
  alias Sandbox.Accounts.User
  alias Sandbox.Accounts.BankAccounts
  alias Sandbox.Accounts.Details
  alias Sandbox.Accounts.Balances
  alias Sandbox.Category

  @base_url "http://localhost:4000"

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

  def merchants, do: @merchants
  def catgories, do: @categories

  def create_account(:user) do
    for n <- @account_names do
      %{
        id: Helpers.generate_id,
        username: n,
        account_number: Helpers.generate_number(12),
        deposit: 100000,
      }
    end

    # users
    # |> Enum.map(
    #   fn %{id: id, username: username, account_number: account_number, deposit: deposit}
    #   ->
    #     {id, %{username: username, account_number: account_number, deposit: deposit}}
    #   end)
  end

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

  def create_institution(:account) do
    for t <- @institutions do
      %{
        id: Helpers.snake_case(t),
        name: t
      }
    end
  end

  # TODO: https://stackoverflow.com/questions/43831451/how-to-count-cumulative-sum-for-a-list-in-elixir
  def create_transactions(:account, user) do
    interval = Helpers.generate_time_interval()

    for i <- interval do
      transaction =
        user
        |> Enum.map(fn t -> %{
          account_id: "acc_#{t.id}",
          amount: Helpers.generate_number(3),
          date: i,
          description: "",
          details: Enum.random(__MODULE__.build_merchant(:merchant)),
          id: "txn_#{t.id}",
          links: %{
            account: "#{@base_url}/accounts/acc_#{t.id}",
            self: "#{@base_url}/accounts/acc_#{t.id}/balances/transactions/txn_#{t.id}",
          },
          running_balance: t.deposit,
          type: "card_payment"
        } end)

      transaction
      |> Enum.map(fn t ->
        %{
          account_id: t.account_id,
          amount: t.amount,
          date: i,
          description: __MODULE__.get_merchant_name(t.details),
          details: t.details,
          id: t.id,
          links: t.links,
          running_balance: __MODULE__.subtract_ammount(t.amount, t.running_balance),
          status: __MODULE__.check_status?(t.details),
          type: t.type,
        }
      end)
    end
  end

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

  def check_status?(details) do
    %{details: %{processing_status: processing_status}} = details

    cond do
      processing_status == "pending" ->
        "pending"
      processing_status == "complete" ->
        "posted"
    end
  end
end
