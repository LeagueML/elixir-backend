defmodule Leagueml.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        league_ml: [
          applications: [
            graphql_api: :permanent,
            prometheus_exporter: :permanent
          ]
        ]
      ]
    ]
  end

  defp deps do
    []
  end
end
