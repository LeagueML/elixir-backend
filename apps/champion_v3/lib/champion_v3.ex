defmodule ChampionV3 do
  @moduledoc false

  use Application

  use RiotApi.RegionMethod, prefix: "/lol/platform/v3"

  defmodule ChampionRotation do
    defstruct [:max_new_player_level, :free_champion_ids_for_new_players, :free_champion_ids]

    @type t :: %__MODULE__{max_new_player_level: integer(), free_champion_ids_for_new_players: [integer()], free_champion_ids: [integer()]}

    def parse(json) do
      %__MODULE__{
        max_new_player_level: json["maxNewPlayerLevel"],
        free_champion_ids_for_new_players: json["freeChampionIdsForNewPlayers"],
        free_champion_ids: json["freeChampionIds"]
      }
    end
  end

  @spec champion_rotation(Region.t()) :: {:ok, ChampionV3.ChampionRotation.t()} | {:error, integer()}
  def champion_rotation(region) do
    case get(region, "/champion-rotations", []) do
      {:ok, json} -> {:ok, ChampionV3.ChampionRotation.parse(json)}
      other -> other
    end
  end
end
