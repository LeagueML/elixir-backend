defmodule GameConstants.GameMode do
    defstruct [:name, :description]

    @type t :: %__MODULE__{
      name: String.t(),
      description: String.t() | nil
    }

    def parse(json) do
      %__MODULE__{
        name: json["gameMode"],
        description: json["description"]
      }
    end

    def data() do
      Dataloader.KV.new(&fetch/2)
    end

    defp fetch(:by_name, args) do
      all_seasons = GameConstants.game_modes()

      Enum.reduce(args, %{}, fn %{name: name} = arg, map ->
        Map.put(map, arg, Enum.find(all_seasons, nil, fn %__MODULE__{name: name2} -> name2 == name end))
      end)
    end
end
