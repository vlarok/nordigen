defmodule Nordigen.Balance do
  import Decoder

  defmodule Balances do
    defmodule BalanceAmount do
      schema(~w(amount currency))
    end

    schema ~w(balanceAmount balanceType creditLimitIncluded lastChangeDateTime lastCommittedTransaction referenceDate) do
      field(:balanceAmount, BalanceAmount)
    end
  end

  schema ~w(balances) do
    field(:balances, Balances)
  end
end
