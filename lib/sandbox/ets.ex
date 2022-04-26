defmodule Sandbox.Ets do
  @moduledoc """
  Ets module, which provide ets table creation and lookup
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

  def get(table_name, key) when is_atom(table_name) and is_binary(key) do
    :ets.lookup(table_name, key)
  end

  def list(table_name) when is_atom(table_name) do
    :ets.tab2list(table_name)
  end
end
