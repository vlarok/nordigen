defmodule Nordigen.Bank do
  import Decoder
  schema ~w(bic countries id logo name transaction_total_days)
end
