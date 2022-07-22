defmodule Ddragon do
  @moduledoc false

  use Application
  import Cachex.Spec

  @cache_name :ddragon_cache
  @default_ttl :timer.hours(12)

  def start(_type, _arg) do
    children = [
      {Cachex, name: @cache_name, hooks: [hook(module: Cachex.Telemetry, name: :ddragon_cachex_telemetry_hook, state: {:ddragon})]}
    ]

    opts = [strategy: :one_for_one, name: Ddragon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def metrics() do
    [
    ]
  end

  def versions() do
    {_, result} = Cachex.fetch(@cache_name, :versions, fn _key ->
      case Ddragon.Client.get("/api/versions.json") do
        {:ok, %{body: response}} when is_list(response) -> {:commit, response
        |> Enum.filter(fn x -> not String.starts_with?(x, "lolpatch") end)
        |> Enum.map(&Ddragon.Version.parse/1)}
        _ -> {:ignore, []}
      end
    end, [ttl: @default_ttl])

    result
  end

  def champion_by_name(version, champion_name) do
    {_, result} = Cachex.fetch(@cache_name, {:champion, version, champion_name}, fn _key ->
      case Ddragon.Client.get("/cdn/" <> version <> "/data/en_US/champion/" <> champion_name <>".json") do
        {:ok, %{body: response}} -> {:commit, Ddragon.Champion.parse(response["data"][champion_name])}
        _ -> {:ignore, nil}
      end
    end, [ttl: @default_ttl])

    result
  end

  def champion_list(version) do
    {_, result} = Cachex.fetch(@cache_name, {:champion_list, version}, fn _key ->
      case Ddragon.Client.get("/cdn/" <> version <>"/data/en_US/champion.json") do
        {:ok, %{body: response}} ->
          {:commit,
            response["data"]
            |> Map.to_list()
            |> Enum.map(fn {k, _v} -> k end)}
        _ -> {:ignore, nil}
      end
    end, [ttl: @default_ttl])

    result
  end
end
