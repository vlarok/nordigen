defmodule Nordigen.Transactions do
  import Decoder

  defmodule TransactionAmount do
    schema(~w(amount currency))
  end

  defmodule DebtorAccount do
    schema(~w(iban))
  end

  defmodule Booked do
    schema ~w(additionalInformation balanceAfterTransaction bankTransactionCode bookingDate bookingDateTime checkId creditorAccount creditorAgent creditorId creditorName currencyExchange debtorAccount debtorAgent debtorName endToEndId entryReference mandateId proprietaryBankTransactionCode purposeCode remittanceInformationStructured remittanceInformationStructuredArray remittanceInformationUnstructured remittanceInformationUnstructuredArray transactionAmount transactionId ultimateCreditor ultimateDebtor valueDate) do
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
