defmodule GraphQLApi.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  defp latest_version(), do: Ddragon.versions() |> List.first() |> Ddragon.Version.version_string()

  import_types RiotApi.Schema
  import_types ChampionV3.Schema
  import_types GameConstants.Schema
  import_types Ddragon.Schema

  node interface do
    resolve_type fn
      %Ddragon.Champion{}, _ -> :champion
      %GameConstants.Map{}, _ -> :map
      %GameConstants.Queue{}, _ -> :queue
      %GameConstants.Season{}, _ -> :season
      _, _ ->
        nil
    end
  end

  query do
    node field do
      resolve fn
        %{type: :champion, id: id}, %{context: %{loader: loader}} ->
          values = [%{version: latest_version(), id: id}]
          loader
          |> Dataloader.load_many(Ddragon.Champion, :by_id, values)
          |> on_load(fn loader ->
            results = Dataloader.get_many(loader, Ddragon.Champion, :by_id, values)
            {:ok, results |> Enum.at(0)}
          end)
        %{type: :map, id: id}, %{context: %{loader: loader}} ->
          values = [%{id: id}]
          loader
          |> Dataloader.load_many(GameConstants.Map, :by_id, values)
          |> on_load(fn loader ->
            results = Dataloader.get_many(loader, GameConstants.Map, :by_id, values)
            {:ok, results |> Enum.at(0)}
          end)
        %{type: :queue, id: id}, %{context: %{loader: loader}} ->
          values = [%{id: id}]
          loader
          |> Dataloader.load_many(GameConstants.Queue, :by_id, values)
          |> on_load(fn loader ->
            results = Dataloader.get_many(loader, GameConstants.Queue, :by_id, values)
            {:ok, results |> Enum.at(0)}
          end)
        %{type: :season, id: id}, %{context: %{loader: loader}} ->
          values = [%{id: id}]
          loader
          |> Dataloader.load_many(GameConstants.Season, :by_id, values)
          |> on_load(fn loader ->
            results = Dataloader.get_many(loader, GameConstants.Season, :by_id, values)
            {:ok, results |> Enum.at(0)}
          end)
      end
    end

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
