defmodule GameConstants.Map do
    defstruct [:id, :name, :notes]

    @type t :: %__MODULE__{
      id: integer(),
      name: String.t(),
      notes: String.t() | nil
    }

    def parse(json) do
      %__MODULE__{
        id: json["mapId"],
        name: json["mapName"],
        notes: json["notes"]
      }
    end

    def data() do
      Dataloader.KV.new(&fetch/2)
    end

    defp fetch(:by_id, args) do
      all_maps = GameConstants.maps()

      Enum.reduce(args, %{}, fn %{id: id} = arg, map ->
        Map.put(map, arg, Enum.find(all_maps, nil, fn %__MODULE__{id: id2} -> id2 == id end))
      end)
    end
end
