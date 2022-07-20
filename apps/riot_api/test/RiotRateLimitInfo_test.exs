defmodule RiotRateLimitInfoTest do
  use ExUnit.Case
  doctest RiotRateLimitInfo

  test "sample 1 parses correctly" do
    sample = %{
      "x-app-rate-limit": "20:100,100:600",
      "x-app-rate-limit-count": "12:100,57:600",
      "x-method-rate-limit": "10:10,100:120",
      "x-method-rate-limit-count": "1:10,1:120"}
    assert {[
      %RiotRateLimitInfo{count: 12, limit: 20, interval_seconds: 100},
      %RiotRateLimitInfo{count: 57, limit: 100, interval_seconds: 600}
    ], [
      %RiotRateLimitInfo{count: 1, limit: 10, interval_seconds: 10},
      %RiotRateLimitInfo{count: 1, limit: 100, interval_seconds: 120}
    ]} = RiotRateLimitInfo.from_http_headers(sample)
  end
end
