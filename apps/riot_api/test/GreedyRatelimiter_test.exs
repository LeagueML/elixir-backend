defmodule GreedyRatelimiterTest do
  use ExUnit.Case
  doctest GreedyRatelimiter

  test "new empty ratelimiter can be reserved" do
    assert {:ok, _} = GreedyRatelimiter.new_empty(1, 1000) |> GreedyRatelimiter.reserve()
  end

  test "new empty cannot be reserved past limit" do
    assert {:ok, new_state} = GreedyRatelimiter.new_empty(1, 1000) |> GreedyRatelimiter.reserve()
    assert {:error, _} = GreedyRatelimiter.reserve(new_state)
  end

  test "empty & empty can be reserved both" do
    a = GreedyRatelimiter.new(0, 1, 10000, DateTime.now!("Etc/UTC"))
    b = GreedyRatelimiter.new(0, 1, 10000, DateTime.now!("Etc/UTC"))

    assert {:ok, _} = GreedyRatelimiter.reserve_all([a, b])
  end

  test "empty & at limit cannot be reserved both" do
    a = GreedyRatelimiter.new(0, 1, 10000, DateTime.now!("Etc/UTC"))
    b = GreedyRatelimiter.new(1, 1, 10000, DateTime.now!("Etc/UTC"))

    assert {:error, _} = GreedyRatelimiter.reserve_all([a, b])
  end

  test "at limit & empty cannot be reserved both" do
    a = GreedyRatelimiter.new(1, 1, 10000, DateTime.now!("Etc/UTC"))
    b = GreedyRatelimiter.new(0, 1, 10000, DateTime.now!("Etc/UTC"))

    assert {:error, _} = GreedyRatelimiter.reserve_all([a, b])
  end

  test "at limit & at limit cannot be reserved both" do
    a = GreedyRatelimiter.new(1, 1, 10000, DateTime.now!("Etc/UTC"))
    b = GreedyRatelimiter.new(1, 1, 10000, DateTime.now!("Etc/UTC"))

    assert {:error, _} = GreedyRatelimiter.reserve_all([a, b])
  end
end
