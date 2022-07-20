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
      extra_applications: [:logger],
      mod: {GraphqlApi, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:absinthe, "~> 1.6.0"},
      {:absinthe_plug, "~> 1.5"},
      {:jason, "~> 1.0"}
      # {:sibling_app_in_umbrella, in_umbrella: true}
    ]
  end
end
