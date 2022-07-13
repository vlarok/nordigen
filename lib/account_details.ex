defmodule Nordigen.AccountDetails do
  import Decoder

  schema(
    ~w(bban bic cashAccountType currency details displayName iban linkedAccounts maskedPan msisdn name ownerAddressUnstructured ownerName product resourceId status usages)
  )
end
