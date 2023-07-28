# Nordigen Elixir Library

This is the client library for [GoCardless](https://gocardless.com).

For a full list of endpoints and arguments, see the [docs](https://nordigen.com/en/account_information_documenation/api-documention/overview/).


## Installation

1. The package can be installed by adding `binance` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nordigen, "~> 0.1.0"}
  ]
end
```

2. Before starting to use API you will need to create a new secret and get your `SECRET_ID` and `SECRET_KEY` from the [Nordigen's Open Banking Portal](https://bankaccountdata.gocardless.com/user-secrets/).

```
 config :nordigen,
  id: SECRET_ID,
  key: SECRET_KEY

```
