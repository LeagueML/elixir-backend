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
      extra_applications: [:riot_api, :ddragon, :logger],
      mod: {ChampionV3, []}
    ]
  end

  defp deps do
    [
      {:riot_api, in_umbrella: true},
      {:ddragon, in_umbrella: true},
      {:dialyxir, "~> 0.5.0", only: [:dev], runtime: false},
      {:telemetry, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:dataloader, "~> 1.0.0"},
      {:absinthe, "~> 1.7.0"}
    ]
  end
end
