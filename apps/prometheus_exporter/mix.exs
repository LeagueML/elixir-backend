defmodule PrometheusExporter.MixProject do
  use Mix.Project

  def project do
    [
      app: :prometheus_exporter,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:game_constants, :graphql_api, :riot_api, :champion_v3, :logger],
      mod: {PrometheusExporter, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:telemetry_metrics_prometheus, "~> 1.1.0"},
      {:dialyxir, "~> 0.5.0", only: [:dev], runtime: false},
      {:telemetry, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:riot_api, in_umbrella: true},
      {:champion_v3, in_umbrella: true},
      {:game_constants, in_umbrella: true}
    ]
  end
end
