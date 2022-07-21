defmodule GreedyRatelimiter do
  @moduledoc """
  A ratelimiter, allowing greedy reserving.
  Greedy reserving means accessing all of the limit at once,
  then having to wait for a long time is allowed.
  This is the easiest way to implement rate limiting
  """

  defstruct [:count, :limit, :seconds, :start_time]

  @type t :: %__MODULE__{
    count: integer(),
    limit: integer(),
    seconds: integer(),
    start_time: DateTime.t()
  }

  @doc """
  creates a new GreedyRatelimiter.t() with an existing count & start_time
  """
  def new(count, limit, seconds, start_time) do
    %__MODULE__{count: count, limit: limit, seconds: seconds, start_time: start_time}
  end

  @doc """
  creates an empty GreedyRatelimiter.t() with count = 0, starting now
  """
  def new_empty(limit, seconds) do
    %__MODULE__{count: 0, limit: limit, seconds: seconds, start_time: DateTime.now!("Etc/UTC")}
  end

  @doc """
  reserve a slot in the GreedyRatelimiter.t() given
  either returns {:ok, new_state} or {:error, to_wait}
  """
  @spec reserve(GreedyRatelimiter.t()) :: ({:ok, GreedyRatelimiter.t()} | {:error, integer()})
  def reserve(state) do
    :telemetry.span([:riot_api, :rate_limiting], %{}, fn ->
      to_wait = (state.seconds * 1000) - DateTime.diff(DateTime.now!("Etc/UTC"), state.start_time, :millisecond)

      new_state = if to_wait <= 0 do
        new_empty(state.limit, state.seconds)
      else
        state
      end

      if new_state.count < new_state.limit do
        :telemetry.execute([:riot_api, :rate_limiting, :success], %{reserved: 1})
        {{:ok, %__MODULE__{new_state | count: new_state.count + 1}}, %{}}
      else
        :telemetry.execute([:riot_api, :rate_limiting, :backoff], %{to_wait: to_wait})
        {{:error, to_wait}, %{}}
      end
    end)
  end

  def reserve_all([]) do
    {:ok, []}
  end

  @doc """
  reserve one slot in each ratelimiter.
  Returns either {:ok, new_states} or {:error, to_wait}
  """
  @spec reserve_all([GreedyRatelimiter.t()]) :: ({:ok, [GreedyRatelimiter.t()]} | {:error, integer()})
  def reserve_all(ratelimiters) do
    # because we just discard the whole list of new ratelimiters when one fails
    # this automatically rolls back any changes we may have made
    # immutability is great!
    Enum.reduce_while(ratelimiters, {:ok, []}, fn ratelimiter, {:ok, acc} ->
      case GreedyRatelimiter.reserve(ratelimiter) do
        {:ok, new_ratelimiter} -> {:cont, {:ok, [new_ratelimiter | acc]}}
        {:error, to_wait} -> {:halt, {:error, to_wait}}
      end
    end)
  end
end
