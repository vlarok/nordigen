defmodule Nordigen.Link do
  defstruct [
    :account_selection,
    :accounts,
    :agreement,
    :created,
    :id,
    :institution_id,
    :link,
    :redirect,
    :redirect_immediate,
    :reference,
    :ssn,
    :status,
    :user_language
  ]

  @keys ~w(account_selection accounts agreement created id institution_id link redirect redirect_immediate reference ssn status user_language)

  def decode(%{} = map) do
    map
    |> Map.take(@keys)
    |> Enum.map(fn {k, v} -> {String.to_existing_atom(k), v} end)
    |> Enum.map(&decode/1)
    |> (fn data -> struct(__MODULE__, data) end).()
  end

  def decode({k, v}), do: {k, v}
end
