defmodule Sandbox.Helpers do
  alias Timex

  @interval 90

  def generate_id do
    for _ <- 1..21, into: "", do: <<Enum.random('0123456789AYJSHFYT')>> |> String.downcase()
  end

  def generate_number(n) do
    for _ <- 1..n, into: "", do: <<Enum.random('0123456789')>>
  end

  def get_last_hour(digits) do
    {_, t} = digits |> String.split_at(-4)

    t
  end

  def snake_case(word) when is_binary(word) do
    word
    |> String.replace("\s", "_")
    |> String.downcase
  end

  def generate_time_interval do
    Date.range(Date.utc_today, Date.add(Date.utc_today, -90))
    |> Enum.to_list
  end

  @doc """
  Travers list to tuple and prepare it for ETS table.
  """
  def list_to_tuple(list, keys \\ []) do
    list
    |> Enum.map(fn t ->
        {t.id, t |> Map.take(keys)}
      end)
  end

  def transaction_tuple(list, keys \\ []) do
    list
    |> Enum.map(fn t ->
        {t.id, t.account_id, t |> Map.take(keys)}
      end)
  end

  def tuple_to_list(list \\ []) do
    list
    |> Enum.map(fn {k, v} ->
      %{id: k} |> Map.merge(v)
    end)
  end
end
