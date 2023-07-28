defmodule Nordigen do
  alias Nordigen.Account
  alias Nordigen.AccountDetails
  alias Nordigen.Bank
  alias Nordigen.Link
  alias Nordigen.Transactions
  alias Nordigen.Balance

  @moduledoc """
  Documentation for `Nordigen`.
  """

  require Logger

  @endpoint Application.get_env(:nordigen, :end_point, "https://bankaccountdata.gocardless.com")

  @doc """
  Get Access Token
  Returns `{:ok, [%Binance.HistoricalTrade{}]}` or `{:error, reason}`.
  ## Example
  {:ok, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUlI1NiJ9.eyJ0b2tlbl90sXBlIjoiYWNjZXNzIiwiZXhwIjoxNjU3NjQwNTczLCJqdGkiOiI3YzcwZDA1MzUwYTA0M2Q4OGVkMGJmNDc5YzlkMWRiNCIsImlkIjoxMzA3NCwic2VjcmV0X2lkIjoiYzFhMDQ0ZjQtOGMyMy00YTQ5LTlkM2MtZWE5OTkzM2ZlZmEwIiwiYWxsb3dlZF9jaWRycyI6WyIwLjAuMC4wLzAiLCI6Oi8wIl19.DZralEAXmHW7NhH0fI6B4NkYgxCwoyPabO3Ryt4u2Tk"}
  """

  def get_access_token() do
    id = Application.get_env(:nordigen, :id)
    key = Application.get_env(:nordigen, :key)

    url = "/api/v2/token/new/"
    headers = [{"accept", "application/json"}, {"Content-Type", "application/json"}]
    payload = "{\"secret_id\":\"#{id}\",\"secret_key\":\"#{key}\"}"

    url
    |> post_request(headers, payload)
    |> format_response(:get_access_token)
  end

  @doc """
  List all Banks by country code.

  Returns `{:ok, list}` or `{:error, reason}`.
  ## Example
  {:ok,
  [
   %Nordigen.Bank{
     bic: "AIPTAU32",
     countries: ["NO", "SE", "FI", "DK", "EE", "LV", "LT", "GB", "NL", "CZ",
      "ES", "PL", "BE", "DE", "AT", "BG", "HR", "CY", "FR", "GR", "HU", "IS",
      "IE", "IT", "LI", "LU", "MT", "PT", "RO", "SK", "SI"],
     id: "AIRWALLEX_AIPTAU32",
     logo: "https://cdn.nordigen.com/ais/AIRWALLEX_AIPTAU32_1.png",
     name: "Airwallex",
     transaction_total_days: "730"
   },...]}
  """
  def list_banks(iso, token) do
    url = "https://bankaccountdata.gocardless.com/api/v2/institutions/?country=#{iso}"
    headers = [{"accept", "application/json"}, {"Authorization", "Bearer #{token}"}]

    url
    |> get_request(headers)
    |> format_response()
  end

  @doc """
  Returns account information by requisition_id

  Returns `{:ok, list}` or `{:error, reason}`.
  ## Example
  {:ok,
  %Nordigen.Account{
   account_selection: false,
   accounts: ["7e944232-bda9-40bc-b784-660c7ab5fe78",
    "99a0bfe2-0bef-46df-bff2-e9ae0c6c5838"],
   agreement: "13c51d1e-5133-4d70-8093-f53caa8dac13",
   created: "2022-07-14T10:47:39.912391Z",
   id: "61bbe16d-875c-4d26-bd1c-091fb1cd79fb",
   institution_id: "SANDBOXFINANCE_SFIN0000",
   link: "https://bankaccountdata.gocardless.com/psd2/start/61bbe16d-875c-4d26-bd1c-091fb1cd79fb/SANDBOXFINANCE_SFIN0000",
   redirect: "http://localhost:4000/wallets/50",
   redirect_immediate: false,
   reference: "619db4fc-0362-11ed-87dd-1e00e2346e69",
   ssn: nil,
   status: "LN",
   user_languages: nil
  }}
  """
  def list_accounts(requisition_id, token) do
    url = "https://bankaccountdata.gocardless.com/api/v2/requisitions/#{requisition_id}/"
    headers = [{"accept", "application/json"}, {"Authorization", "Bearer #{token}"}]

    url
    |> get_request(headers)
    |> format_response(:list_accounts)
  end

  @doc """
  List account transactions by account_id

  Returns `{:ok, list}` or `{:error, reason}`.
  ## Example
  [{:ok,
  %Nordigen.Transactions.Booked{
    additionalInformation: nil,
    balanceAfterTransaction: nil,
    bankTransactionCode: "PMNT",
    bookingDate: "2022-07-12",
    bookingDateTime: nil,
    checkId: nil,
    creditorAccount: nil,
    creditorAgent: nil,
    creditorId: nil,
    creditorName: nil,
    currencyExchange: nil,
    debtorAccount: nil,
    debtorAgent: nil,
    debtorName: nil,
    endToEndId: nil,
    entryReference: nil,
    mandateId: nil,
    proprietaryBankTransactionCode: nil,
    purposeCode: nil,
    remittanceInformationStructured: nil,
    remittanceInformationStructuredArray: nil,
    remittanceInformationUnstructured: "PAYMENT Alderaan Coffe",
    remittanceInformationUnstructuredArray: nil,
    transactionAmount: %Nordigen.Transactions.TransactionAmount{
      amount: "-15.00",
      currency: "EUR"
    },
    transactionId: "2022071201721808-1",
    ultimateCreditor: nil,
    ultimateDebtor: nil,
    valueDate: "2022-07-12"
  },..]
  """

  def list_account_transactions(account_id, token) do
    url = "https://bankaccountdata.gocardless.com/api/v2/accounts/#{account_id}/transactions/"

    headers = [{"accept", "application/json"}, {"Authorization", "Bearer #{token}"}]

    url
    |> get_request(headers)
    |> format_response(:account_transactions)
  end

  @doc """
  List account balances

  Returns `{:ok, list}` or `{:error, reason}`.
  ## Example
  {:ok,
  %Nordigen.Balance{
   balances: [
     %Nordigen.Balance.Balances{
       balanceAmount: %Nordigen.Balance.Balances.BalanceAmount{
         amount: "1913.12",
         currency: "EUR"
       },
       balanceType: "expected",
       creditLimitIncluded: nil,
       lastChangeDateTime: nil,
       lastCommittedTransaction: nil,
       referenceDate: "2022-07-14"
     },...]}
  """
  def get_account_balances(account_id, token) do
    url = "https://bankaccountdata.gocardless.com/api/v2/accounts/#{account_id}/balances/"

    headers = [{"accept", "application/json"}, {"Authorization", "Bearer #{token}"}]

    url
    |> get_request(headers)
    |> format_response(:account_balances)
  end

  def get_account_details(account_id, token) do
    url = "https://bankaccountdata.gocardless.com/api/v2/accounts/#{account_id}/details/"

    headers = [{"accept", "application/json"}, {"Authorization", "Bearer #{token}"}]

    url
    |> get_request(headers)
    |> format_response(:account_details)
  end

  @doc """
  Build Authentication Link
  Returns `{:ok, [%Binance.HistoricalTrade{}]}` or `{:error, reason}`.
  ## Example
  {:ok,
  %Nordigen.Link{
   account_selection: false,
   accounts: [],
   agreement: "",
   created: "2022-07-14T10:47:39.912391Z",
   id: "61bbe16d-875c-4d26-bd1c-091fb1cd79fb",
   institution_id: "SANDBOXFINANCE_SFIN0000",
   link: "https://bankaccountdata.gocardless.com/psd2/start/61bbe16d-875c-4d26-bd1c-091fb1cd79fb/SANDBOXFINANCE_SFIN0000",
   redirect: "http://localhost:4000/wallets/50",
   redirect_immediate: false,
   reference: "619db4fc-0362-11ed-87dd-1e00e2346e69",
   ssn: nil,
   status: "CR",
   user_language: "EN"
  }}
  """
  def requisition_link(redirect, institution_id, token, language_iso \\ "EN") do
    reference = UUID.uuid1()

    url = "/api/v2/requisitions/"

    headers = [
      {"accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{token}"}
    ]

    payload =
      "{\"redirect\":\"#{redirect}\",\"institution_id\":\"#{institution_id}\",\"reference\":\"#{reference}\",\"user_language\":\"#{language_iso}\"}"

    url
    |> post_request(headers, payload)
    |> format_response()
  end

  defp format_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    response_list = Poison.decode!(body)

    bank_list =
      for bank <- response_list do
        Bank.decode(bank)
      end

    {:ok, bank_list}
  end

  defp format_response({:ok, %HTTPoison.Response{body: body, status_code: 201}}) do
    link =
      body
      |> Poison.decode!()
      |> Link.decode()

    {:ok, link}
  end

  defp format_response(
         {:ok, %HTTPoison.Response{body: body, status_code: 200}},
         :get_access_token
       ) do
    %{"access" => access} = Poison.decode!(body)

    {:ok, access}
  end

  defp format_response(
         {:ok, %HTTPoison.Response{body: body, status_code: 200}},
         :list_accounts
       ) do
    requisition = Poison.decode!(body)

    account_requisition = Account.decode(requisition)

    {:ok, account_requisition}
  end

  defp format_response(
         {:ok, %HTTPoison.Response{body: body, status_code: 200}},
         :account_details
       ) do
    %{"account" => account} = Poison.decode!(body)

    account_details = AccountDetails.decode(account)

    {:ok, account_details}
  end

  defp format_response(
         {:ok, %HTTPoison.Response{body: body, status_code: 200}},
         :account_transactions
       ) do
    %{"transactions" => transactions} = Poison.decode!(body)

    list = Transactions.decode(transactions)

    {:ok, list}
  end

  defp format_response(
         {:ok, %HTTPoison.Response{body: body, status_code: 200}},
         :account_balances
       ) do
    balances = Poison.decode!(body)

    list = Balance.decode(balances)

    {:ok, list}
  end

  defp format_response({:ok, %HTTPoison.Response{status_code: status_code} = response}, _)
       when status_code == 401 do
    Logger.warn(~s(Nordigen API response: #{inspect(response)}))

    {:error, :invalid_token}
  end

  defp format_response({:ok, %HTTPoison.Response{status_code: status_code} = response}, _)
       when status_code >= 400 do
    Logger.warn(~s(Nordigen API response: #{inspect(response)}))

    {:error, "Nordigen service could not be reached."}
  end

  defp format_response({:error, %HTTPoison.Error{reason: reason} = error}, _) do
    Logger.warn(~s(
    There is an error when fetching access token: #{reason}

    response: #{inspect(error)}
  ))

    {:error, reason}
  end

  defp post_request(url, headers, payload) do
    @endpoint
    |> URI.merge(url)
    |> URI.to_string()
    |> HTTPoison.post(payload, headers)
  end

  defp get_request(url, headers) do
    @endpoint
    |> URI.merge(url)
    |> URI.to_string()
    |> HTTPoison.get(headers)
  end
end
