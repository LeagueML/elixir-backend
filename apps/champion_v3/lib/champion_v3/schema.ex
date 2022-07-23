defmodule ChampionV3.Schema do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  object :champion_rotation do
    field :max_new_player_level, :integer
    field :free_champions_for_new_players, list_of(:champion)
    field :free_champions, list_of(:champion)
  end

  object :champion_v3_queries do
    field :champion_rotation, :champion_rotation do
      arg :region, non_null(:region)
      resolve fn %{region: region}, %{context: %{loader: loader}} ->
        case ChampionV3.champion_rotation(region) do
          {:ok, %ChampionV3.ChampionRotation{
            max_new_player_level: max_new_player_level,
            free_champion_ids: free_champion_ids,
            free_champion_ids_for_new_players: free_champion_ids_for_new_players
          }} ->
            version = Ddragon.versions() |> List.first() |> Ddragon.Version.version_string()
            fc = Enum.map(free_champion_ids, fn f -> %{key: f, version: version} end)
            fcnp = Enum.map(free_champion_ids_for_new_players, fn f -> %{key: f, version: version} end)
            loader
            |> Dataloader.load_many(Ddragon.Champion, :by_key, fc)
            |> Dataloader.load_many(Ddragon.Champion, :by_key, fcnp)
            |> on_load(fn loader ->
              free_champions = Dataloader.get_many(loader, Ddragon.Champion, :by_key, fc)
              free_champions_for_new_players = Dataloader.get_many(loader, Ddragon.Champion, :by_key, fcnp)
              {:ok, %{
                max_new_player_level: max_new_player_level,
                free_champions: free_champions,
                free_champions_for_new_players: free_champions_for_new_players
              }}
            end)
          {:error, reason} -> {:error, reason}
        end
      end
    end
  end
end
