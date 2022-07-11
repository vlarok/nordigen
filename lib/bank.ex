defmodule Nordigen.Bank do
  defstruct [:bic, :countries, :id, :logo, :name, :transaction_total_days]

  @keys ~w(bic countries id logo name transaction_total_days)

  def decode(%{} = map) do
    map
    |> Map.take(@keys)
    |> Enum.map(fn {k, v} -> {String.to_existing_atom(k), v} end)
    |> Enum.map(&decode/1)
    |> (fn data -> struct(__MODULE__, data) end).()
  end

  def decode({k, v}), do: {k, v}
end
