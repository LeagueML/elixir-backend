defmodule GameConstants do
  @moduledoc false

  use Application

  @cache_name GameConstants.Cache
  @default_ttl :timer.hours(12)

  def start(_type, _arg) do
    children = [
      {Cachex, name: @cache_name, hooks: [Cachex.Telemetry]},
      {GameConstants.Downloader}
    ]

    opts = [strategy: :one_for_one, name: GameConstants.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def metrics() do
    default_buckets = [0.05, 0.1, 0.25, 0.5, 1]
    [
      Telemetry.Metrics.distribution("tesla.request.stop.duration", [unit: {:native, :millisecond}, reporter_options: [buckets: default_buckets]]),
      Telemetry.Metrics.counter("cachex.fetch.commit"),
      Telemetry.Metrics.counter("cachex.fetch.ok")
    ]
  end

  defmodule Season do
    defstruct [:id, :name]

    @type t :: %__MODULE__{
      id: integer(),
      name: String.t()
    }

    def parse(json) do
      %__MODULE__{
        id: json["id"],
        name: json["season"]
      }
    end
  end

  def seasons() do
    {_, result} = Cachex.fetch(@cache_name, :seasons, fn _key ->
      case GameConstants.Client.get("/seasons.json") do
        {:ok, response} when is_list(response) -> {:commit, Enum.map(response, &Season.parse/1)}
        _ -> {:ignore, []}
      end
    end, [ttl: @default_ttl])

    result
  end
end
