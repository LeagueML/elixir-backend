defmodule GameConstants.Client do
  use Tesla

  plug Tesla.Middleware.DecompressResponse
  plug Tesla.Middleware.BaseUrl, "https://static.developer.riotgames.com/docs/lol/"
  plug Tesla.Middleware.JSON
end
