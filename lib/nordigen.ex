defmodule Nordigen do
  alias Nordigen.Bank
  alias Nordigen.Link

  @moduledoc """
  Documentation for `Nordigen`.
  """

  require Logger

  @endpoint Application.get_env(:nordigen, :end_point, "https://ob.nordigen.com")

  @doc """
  Get Access Token
  https://ob.nordigen.com/api/v2/token/new/
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
  List all Banks by country code
  https://ob.nordigen.com/api/v2/institutions/?country=EE

  Returns `{:ok, list}` or `{:error, reason}`.
  ## Example
  {:ok,  [
   %{
     "bic" => "AIPTAU32",
     "countries" => ["NO", "SE", "FI", "DK", "EE", "LV", "LT", "GB", "NL", "CZ",
      "ES", "PL", "BE", "DE", "AT", "BG", "HR", "CY", "FR", "GR", "HU", "IS",
      "IE", "IT", "LI", "LU", "MT", "PT", "RO", "SK", "SI"],
     "id" => "AIRWALLEX_AIPTAU32",
     "logo" => "https://cdn.nordigen.com/ais/AIRWALLEX_AIPTAU32_1.png",
     "name" => "Airwallex",
     "transaction_total_days" => "730"
   },...]}
  """
  def list_banks(iso, token) do
    url = "https://ob.nordigen.com/api/v2/institutions/?country=#{iso}"
    headers = [{"accept", "application/json"}, {"Authorization", "Bearer #{token}"}]

    url
    |> get_request(headers)
    |> format_response()
  end

  @doc """
  Build Authentication Link
  https://ob.nordigen.com/api/v2/requisitions/
  Returns `{:ok, [%Binance.HistoricalTrade{}]}` or `{:error, reason}`.
  ## Example
  {:ok,
  %{
    "account_selection" => false,
    "accounts" => [],
    "agreement" => "",
    "created" => "2022-07-11T15:52:33.166703Z",
    "id" => "4c4a1294-c376-45cb-bfa3-e597b48136cd",
    "institution_id" => "LHV_LHVBEE22",
    "link" => "https://ob.nordigen.com/psd2/start/4c4a0094-c976-45lb-bfa3-e597b21136cd/LHV_LHVBEE22",
    "redirect" => "http://localhost:4000",
    "redirect_immediate" => false,
    "reference" => "79d92da6-0131-11ed-ad4d-1e00e2346e69",
    "ssn" => nil,
    "status" => "CR",
    "user_language" => "EN"
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
