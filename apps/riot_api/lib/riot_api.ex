defmodule RiotApi do
  @moduledoc false

  use Application

  @registry_name RiotApi.RegionRegistry
  @finch_name RiotApi.FinchPool

  def start(_type, _args) do
    api_token = Application.fetch_env!(:riot_api, :riot_api_token)

    adapter = {Tesla.Adapter.Finch, name: @finch_name}

    app_configs = RiotApi.Region.all_regions()
    |> Enum.concat(RiotApi.Platform.all_platforms())
    |> Enum.map(fn r -> %{
      id: r,
      start: {
        RiotApi.RiotApp,
        :start_link,
        [
          api_token, r, adapter,
          [name: {:via, Registry, {@registry_name, r}}]
        ]
      }
    } end)

    children = [
      {Finch, name: @finch_name},
      {Registry, keys: :unique, name: @registry_name},
    ]
    |> Enum.concat(app_configs)

    opts = [strategy: :one_for_one, name: RiotApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @spec get_app_instance((RiotApi.Region.t() | RiotApi.Platform.t())) :: pid()
  defp get_app_instance(region_or_platform) do
    [{pid, nil}] = Registry.lookup(@registry_name, region_or_platform)
    pid
  end

  @spec app_request((RiotApi.Region.t() | RiotApi.Platform.t()), Tesla.Env.url(), Tesla.Env.query()) :: RiotApp.response()
  def app_request(region_or_platform, url, query) do
    pid = get_app_instance(region_or_platform)
    RiotApi.RiotApp.request(pid, url, query)
  end

  @spec metrics() :: [Telemetry.Metrics.t()]
  def metrics(), do:
  [
    Telemetry.Metrics.distribution("riot_api.rate_limiting.stop.duration", [unit: {:native, :millisecond}, reporter_options: [buckets: [0.1, 0.5, 1]]]),
    Telemetry.Metrics.distribution("riot_api.request.app.stop.duration", [unit: {:native, :millisecond}, tags: [:region_or_platform], reporter_options: [buckets: [0.1, 0.5, 1]]]),
    Telemetry.Metrics.distribution("riot_api.request.method.stop.duration", [unit: {:native, :millisecond}, tags: [:region_or_platform, :method], reporter_options: [buckets: [0.1, 0.5, 1]]]),
    Telemetry.Metrics.counter("riot_api.rate_limiting.success.reserved", []),
    Telemetry.Metrics.distribution("riot_api.rate_limiting.backoff.to_wait", [unit: {:second, :millisecond}, reporter_options: [buckets: [0.01, 0.5, 1]]])
  ]
end
