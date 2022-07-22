defmodule RiotApi.RiotClient do
  @type riot_api_token :: String.t()

  @spec get_base_url((RiotApi.Region.t() | RiotApi.Platform.t())) :: String.t()
  def get_base_url(region_or_platform) do
    "https://" <> Atom.to_string(region_or_platform) <>".api.riotgames.com/"
  end

  @spec new(riot_api_token(), (RiotApi.Region.t() | RiotApi.Platform.t()), Tesla.Client.adapter()) :: Tesla.Client.t()
  def new(riot_api_token, region_or_platform, adapter) do
    middleware = [
      Tesla.Middleware.DecompressResponse,
      {Tesla.Middleware.BaseUrl, get_base_url(region_or_platform)},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"X-Riot-Token", riot_api_token }]},
      Tesla.Middleware.Telemetry,
    ]

    Tesla.client(middleware, adapter)
  end
end
