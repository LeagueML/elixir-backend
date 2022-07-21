defmodule RiotApi.RiotRateLimitInfo do
  @moduledoc """
  Utilities for parsing and storing riot provided rate limit information
  """

  @type t :: %__MODULE__{
    count: integer(),
    limit: integer(),
    interval_seconds: integer()
  }
  defstruct [:count, :limit, :interval_seconds]

  @doc """
  Parses app and ratelimiting info from HTTP headers
  Returns a tuple {app_limits, method_limits}
  """
  @spec from_http_headers(map()) :: {[t()], [t()]}
  def from_http_headers(%{
    "x-app-rate-limit" => app_rate_limit_string,
    "x-app-rate-limit-count" => app_rate_limit_count_string,
    "x-method-rate-limit" => method_rate_limit_string,
    "x-method-rate-limit-count" => method_rate_limit_count_string}) do

    parsed_app_rate_limit = parse_http_header(app_rate_limit_string)
    parsed_app_rate_limit_count = parse_http_header(app_rate_limit_count_string)

    parsed_method_rate_limit = parse_http_header(method_rate_limit_string)
    parsed_method_rate_limit_count = parse_http_header(method_rate_limit_count_string)

    app = combine_limit_and_count(parsed_app_rate_limit, parsed_app_rate_limit_count)
    method = combine_limit_and_count(parsed_method_rate_limit, parsed_method_rate_limit_count)

    {app, method}
  end

  defp combine_limit_and_count(limits, counts) do
    limits
    |> Enum.map(fn {limit, limit_seconds} ->
      {count, _} = Enum.find(counts, fn {_count, count_seconds} -> count_seconds == limit_seconds end)
      %__MODULE__{count: count, limit: limit, interval_seconds: limit_seconds}
    end)
  end

  defp parse_http_header(value) do
    String.split(value, ",")
    |> Enum.map(fn limit ->
      String.split(limit, ":")
      |> Enum.map(fn s ->
        {i, ""} = Integer.parse(s)
         i
      end)
      |> List.to_tuple()
    end)
  end
end
