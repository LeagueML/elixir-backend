defmodule ChampionV3.Schema do
  use Absinthe.Schema.Notation

  object :champion_rotation do
    field :max_new_player_level, :integer
    # TODO: Resolve to champion info (list is champion IDs)
    field :free_champion_ids_for_new_players, list_of(:integer)
    # TODO: Resolve to champion info (list is champion IDs)
    field :free_champion_ids, list_of(:integer)
  end

  object :champion_v3_queries do
    field :champion_rotation, :champion_rotation do
      arg :region, non_null(:region)
      resolve fn %{region: region}, _ ->
        case ChampionV3.champion_rotation(region) do
          {:ok, %ChampionV3.ChampionRotation{
            max_new_player_level: max_new_player_level,
            free_champion_ids: free_champion_ids,
            free_champion_ids_for_new_players: free_champion_ids_for_new_players
          }} -> {:ok, %{
            max_new_player_level: max_new_player_level,
            free_champion_ids: free_champion_ids,
            free_champion_ids_for_new_players: free_champion_ids_for_new_players
          }}
          {:error, _} -> :error
        end
      end
    end
  end
end
