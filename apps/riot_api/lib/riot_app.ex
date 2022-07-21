defmodule RiotApp do
  use GenServer

  @spec start_link(RiotClient.riot_api_token(), (Region.t() | Platform.t()), Tesla.Client.adapter(), GenServer.options()) :: GenServer.on_start()
  def start_link(api_token, region_or_platform, adapter, opts) do
    GenServer.start_link(__MODULE__, {api_token, region_or_platform, adapter}, opts)
  end

  @type init_args :: {RiotClient.riot_api_token(), (Region.t() | Platform.t()), Tesla.Client.adapter()}

  @impl true
  @spec init(init_args()) :: {:ok, state()}
  def init({api_token, region_or_platform, adapter}) do
    client = RiotClient.new(api_token, region_or_platform, adapter)
    {:ok, {[], client, region_or_platform}}
  end

  @type state :: {[GreedyRatelimiter], Tesla.Env.client(), (Region.t() | Platform.t())}

  @impl true
  @spec handle_call({:request, Tesla.Env.url(), Tesla.Env.query()}, any(), state) :: {:reply, response(), state()}
  def handle_call({:request, url, query}, _from, {ratelimiters, client, region_or_platform}) do
    metadata = %{url: url, query: query, region_or_platform: region_or_platform}
    :telemetry.span([:riot_api, :request, :app], metadata, fn ->
      case GreedyRatelimiter.reserve_all(ratelimiters) do
        {:ok, new_ratelimiters} ->
          case Tesla.get(client, url, query: query) do
            {:ok, response} ->
              case response.status do
                x when x >= 200 and x < 300 ->
                  {app, method_limit_info} = RiotRateLimitInfo.from_http_headers(Map.new(response.headers))
                  final_ratelimiters = apply_infos(new_ratelimiters, app)
                  {{:reply, {:ok, %{method_limit_info: method_limit_info, body: response.body}}, {final_ratelimiters, client, region_or_platform}}, metadata}
                429 ->
                  # rate limit exceeded somehow. Wait for retry-after. Reset ratelimit state.
                  backoff = case Integer.parse(Map.get(response.headers, "retry-after")) do
                    {backoff, _} -> backoff
                    _ -> 30 # if no retry-after is given, wait 30s
                  end
                  {{:reply, {:error, backoff}, {[GreedyRatelimiter.new(1, 1, backoff, DateTime.now!("Etc/UTC"))], client, region_or_platform}}, metadata}
                other ->
                  other |> IO.inspect()
                  # in case of 5xx or so, just wait 1s, don't reset ratelimiting, hope it resolves itself!
                  {{:reply, {:error, 1}, {new_ratelimiters, client}}, metadata}
              end
            {:error, reason} -> {{:reply, {:tesla_error, reason}, {new_ratelimiters, client, region_or_platform}}, metadata}
          end
        {:error, wait_time} -> {{:reply, {:error, wait_time}, {ratelimiters, client, region_or_platform}}, metadata}
      end
    end)
  end

  @type response :: {:ok, %{method_limit_info: [RiotRateLimitInfo.t()], body: Tesla.Env.body()}} | {:error, integer()} | {:tesla_error, any()}
  @spec request(pid(), Tesla.Env.url(), Tesla.Env.query()) :: response()
  def request(pid, url, query) do
    GenServer.call(pid, {:request, url, query})
  end

  def apply_infos(ratelimiters, infos) do
    infos
    |> Enum.map(fn %{count: count, limit: limit, interval_seconds: seconds} ->
      found = Enum.find(ratelimiters, nil, fn %{seconds: s, limit: l} -> seconds == s and limit == l end)
      case found do
        nil -> GreedyRatelimiter.new(count, limit, seconds, DateTime.now!("Etc/UTC"))
        found -> %GreedyRatelimiter{found | count: count}
      end
    end)
  end
end
