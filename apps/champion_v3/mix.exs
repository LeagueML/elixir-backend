defmodule ChampionV3.MixProject do
  use Mix.Project

  def project do
    [
      app: :champion_v3,
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

  def application do
    [
      extra_applications: [:logger],
      mod: {ChampionV3, []}
    ]
  end

  defp deps do
    [
      {:riot_api, in_umbrella: true},
      {:telemetry, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6.1"}
    ]
  end
end
