defmodule GameConstants.MixProject do
  use Mix.Project

  def project do
    [
      app: :game_constants,
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
      extra_applications: [:logger],
      mod: {GameConstants, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cachex, "~> 3.4"},
      {:tesla, "~> 1.4"},
      {:dialyxir, "~> 0.5.0", only: [:dev], runtime: false},
      {:telemetry, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:absinthe, "~> 1.6.0"}
    ]
  end
end