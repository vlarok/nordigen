defmodule Nordigen.Transactions do
  import Decoder

  defmodule TransactionAmount do
    schema(~w(amount currency))
  end

  defmodule DebtorAccount do
    schema(~w(iban))
  end

  defmodule Booked do
    schema ~w(bankTransactionCode bookingDate debtorAccount debtorName remittanceInformationUnstructured transactionAmount transactionId valueDate) do
      field(:transactionAmount, TransactionAmount)
      field(:debtorAccount, DebtorAccount)
    end
  end

  defmodule Pending do
    schema ~w(transactionAmount valueDate remittanceInformationUnstructured) do
      field(:transactionAmount, TransactionAmount)
    end
  end

  schema ~w(booked pending) do
    field(:booked, Booked)
    field(:pending, Pending)
  end
end
