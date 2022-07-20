defmodule RiotApi do
  @moduledoc false

  use Application

  @registry_name RiotApi.RegionRegistry
  @finch_name RiotApi.FinchPool

  def start(_type, _args) do
    api_token = Application.fetch_env!(:riot_api, :riot_api_token)

    adapter = {Tesla.Adapter.Finch, name: @finch_name}

    app_configs = Region.all_regions()
    |> Enum.concat(Platform.all_platforms())
    |> Enum.map(fn r -> %{
      id: r,
      start: {
        RiotApp,
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

  @spec get_app_instance((Region.t() | Platform.t())) :: pid()
  defp get_app_instance(region_or_platform) do
    [{pid, nil}] = Registry.lookup(@registry_name, region_or_platform)
    pid
  end

  @spec app_request((Region.t() | Platform.t()), Tesla.Env.url(), Tesla.Env.query()) :: RiotApp.response()
  def app_request(region_or_platform, url, query) do
    pid = get_app_instance(region_or_platform)
    RiotApp.request(pid, url, query)
  end
end
