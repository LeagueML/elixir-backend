defmodule PrometheusExporter do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {TelemetryMetricsPrometheus, [metrics: metrics()]}
    ]

    opts = [strategy: :one_for_one, name: PrometheusExporter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp metrics, do:
    []
    |> Enum.concat(RiotApi.metrics())
    |> Enum.concat(GraphQLApi.metrics())
end
