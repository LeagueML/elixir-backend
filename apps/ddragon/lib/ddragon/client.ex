defmodule Ddragon.Client do
  use Tesla

  adapter Tesla.Adapter.Hackney, recv_timeout: 30_000

  plug Tesla.Middleware.DecompressResponse
  plug Tesla.Middleware.BaseUrl, "https://ddragon.leagueoflegends.com/"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Telemetry

end
