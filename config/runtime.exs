import Config

config :riot_api,
  riot_api_token: System.get_env("RIOT_API_TOKEN") || raise "RIOT_API_TOKEN environment variable is required"
