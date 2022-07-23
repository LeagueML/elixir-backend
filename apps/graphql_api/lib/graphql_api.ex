defmodule GraphQLApi do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: GraphQLApi.Plug, options: [port: 8080]}
    ]

    opts = [strategy: :one_for_one, name: GraphQLApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def metrics() do
    default_buckets = [0.05, 0.1, 0.25, 0.5, 1]
    [
      Telemetry.Metrics.distribution("absinthe.execute.operation.stop.duration", [unit: {:native, :millisecond}, reporter_options: [buckets: default_buckets]]),
      Telemetry.Metrics.distribution("absinthe.resolve.field.stop.duration", [unit: {:native, :millisecond}, reporter_options: [buckets: default_buckets]]),
      Telemetry.Metrics.distribution("absinthe.middleware.batch.stop.duration", [unit: {:native, :millisecond}, reporter_options: [buckets: default_buckets]]),
      Telemetry.Metrics.distribution("dataloader.source.run.stop.duration", [unit: {:native, :millisecond}, reporter_options: [buckets: default_buckets]]),
      Telemetry.Metrics.distribution("dataloader.source.batch.run.stop.duration", [unit: {:native, :millisecond}, reporter_options: [buckets: default_buckets]]),
    ]
  end
end
