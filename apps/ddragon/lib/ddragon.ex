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
end
