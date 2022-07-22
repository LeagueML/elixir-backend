defmodule GameConstants.Client do
  use Tesla

  adapter Tesla.Adapter.Hackney, recv_timeout: 30_000

  plug Tesla.Middleware.DecompressResponse
  plug Tesla.Middleware.BaseUrl, "https://static.developer.riotgames.com/docs/lol/"
  plug Tesla.Middleware.JSON

end
