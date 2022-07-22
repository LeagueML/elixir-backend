defmodule GraphQLApi.Schema do
  use Absinthe.Schema

  import_types RiotApi.Schema
  import_types ChampionV3.Schema
  import_types GameConstants.Schema
  import_types Ddragon.Schema

  query do
    import_fields :champion_v3_queries
    import_fields :game_constants_queries
    import_fields :ddragon_queries
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(GameConstants.Season, GameConstants.Season.data())
      |> Dataloader.add_source(GameConstants.Queue, GameConstants.Queue.data())
      |> Dataloader.add_source(GameConstants.Map, GameConstants.Map.data())
      |> Dataloader.add_source(GameConstants.GameMode, GameConstants.GameMode.data())
      |> Dataloader.add_source(Ddragon.Champion, Ddragon.Champion.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins() do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
