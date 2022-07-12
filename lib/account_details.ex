defmodule Nordigen.AccountDetails do
  import Decoder

  schema(~w(cashAccountType currency iban name product resourceId status))
end
