defmodule Nordigen.Account do
  import Decoder
  schema ~w(account_selection accounts agreement created id institution_id link redirect redirect_immediate reference ssn status user_languages)
end
