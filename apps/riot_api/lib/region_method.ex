defmodule RiotApi.RegionMethod do
  defmacro __using__(prefix: prefix) do
    quote do
      @type response :: {:ok, Tesla.Env.body()}
                | {:error, integer()}
                | {:tesla_error, any()}

      defmodule __MODULE__.Worker do
        use GenServer

        @prefix unquote(prefix)

        @spec start_link(RiotApi.Region.t(), GenServer.options()) :: GenServer.on_start()
        def start_link(region, opts) do
          GenServer.start_link(__MODULE__, {region}, opts)
        end

        @impl true
        def init({region}) do
          {:ok, {region, []}}
        end

        @type state :: {Region.t(), [RiotApi.GreedyRatelimiter.t()]}

        # TODO: Change this to use stuff from https://hexdocs.pm/tesla/Tesla.Middleware.Telemetry.html#module-url-event-scoping-with-tesla-middleware-pathparams-and-tesla-middleware-keeprequest
        @impl true
        @spec handle_call({:request, Tesla.Env.url(), Tesla.Env.query()}, any(), state())
        :: {:reply, {:ok, Tesla.Env.body()}
                  | {:error, integer()}
                  | {:tesla_error, any()}, state()}
        def handle_call({:request, url, query}, _from, {region, limiters}) do
          metadata = %{url: url, query: query, region_or_platform: region, method: @prefix}
          :telemetry.span([:riot_api, :request, :method], metadata, fn ->
            case RiotApi.GreedyRatelimiter.reserve_all(limiters) do
              {:ok, new_limiters} ->
                response = RiotApi.app_request(region, @prefix <> url, query)
                case response do
                  {:ok, %{method_limit_info: info, body: body}} ->
                    final_limiters = RiotApi.RiotApp.apply_infos(new_limiters, info)
                    {{:reply, {:ok, body}, {region, final_limiters}}, metadata}
                  other -> {{:reply, other, {region, limiters}}, metadata}
                end
              {:error, i} -> {{:reply, {:error, i}, {region, limiters}}, metadata}
            end
          end)
        end
      end

      @registry_name __MODULE__.Registry

      def start(_type, _args) do
        workers =
          RiotApi.Region.all_regions()
          |> Enum.map(fn r -> %{
            id: r,
            start: {
              __MODULE__.Worker,
              :start_link,
              [
                r,
                [name: {:via, Registry, {@registry_name, r}}]
              ]
            }
          } end)

        children = [
          {Registry, keys: :unique, name: @registry_name}
        ]
        |> Enum.concat(workers)

        opts = [strategy: :one_for_one, name: __MODULE__.Supervisor]
        Supervisor.start_link(children, opts)
      end

      @spec get_instance(RiotApi.Region.t()) :: pid()
      defp get_instance(region) do
        [{pid, nil}] = Registry.lookup(@registry_name, region)
        pid
      end

      @spec get(RiotApi.Region.t(), Tesla.Env.url(), Tesla.Env.query()) :: response()
      defp get(region, postfix, query) do
        instance = get_instance(region)
        GenServer.call(instance, {:request, postfix, query})
      end

      @spec metrics() :: [any()]
      def metrics(), do:
      [
      ]
    end
  end
end
