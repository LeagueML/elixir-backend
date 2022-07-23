defmodule GameConstants do
  @moduledoc false

  use Application
  import Cachex.Spec

  @cache_name :game_constants_cache
  @default_ttl :timer.hours(12)

  def start(_type, _arg) do
    children = [
      {Cachex, name: @cache_name, hooks: [hook(module: Cachex.Telemetry, name: :game_constants_cachex_telemetry_hook, state: {:game_constants})]}
    ]

    opts = [strategy: :one_for_one, name: GameConstants.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def seasons() do
    {_, result} = Cachex.fetch(@cache_name, :seasons, fn _key ->
      case GameConstants.Client.get("/seasons.json") do
        {:ok, %{body: response}} when is_list(response) -> {:commit, Enum.map(response, &GameConstants.Season.parse/1)}
        _ -> {:ignore, []}
      end
    end, [ttl: @default_ttl])

    result
  end

  def queues() do
    {_, result} = Cachex.fetch(@cache_name, :queues, fn _key ->
      case GameConstants.Client.get("/queues.json") do
        {:ok, %{body: response}} when is_list(response) -> {:commit, Enum.map(response, &GameConstants.Queue.parse/1)}
        _ -> {:ignore, []}
      end
    end, [ttl: @default_ttl])

    result
  end

  def maps() do
    {_, result} = Cachex.fetch(@cache_name, :maps, fn _key ->
      case GameConstants.Client.get("/maps.json") do
        {:ok, %{body: response}} when is_list(response) -> {:commit, Enum.map(response, &GameConstants.Map.parse/1)}
        _ -> {:ignore, []}
      end
    end, [ttl: @default_ttl])

    result
  end

  def game_modes() do
    {_, result} = Cachex.fetch(@cache_name, :game_modes, fn _key ->
      case GameConstants.Client.get("/gameModes.json") do
        {:ok, %{body: response}} when is_list(response) -> {:commit, Enum.map(response, &GameConstants.GameMode.parse/1)}
        _ -> {:ignore, []}
      end
    end, [ttl: @default_ttl])

    result
  end
end
