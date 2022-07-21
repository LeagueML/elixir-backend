defmodule GraphqlApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :graphql_api,
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
      extra_applications: [:champion_v3, :logger],
      mod: {GraphQLApi, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 0.5.0", only: [:dev], runtime: false},
      {:plug_cowboy, "~> 2.0"},
      {:absinthe, "~> 1.6.0"},
      {:absinthe_plug, "~> 1.5"},
      {:jason, "~> 1.0"},
      {:champion_v3, in_umbrella: true},
      {:telemetry, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6.1"}
    ]
  end
end
