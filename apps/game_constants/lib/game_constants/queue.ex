defmodule GameConstants.Queue do
    defstruct [:id, :map, :description, :notes]

    @type t :: %__MODULE__{
      id: integer(),
      map: String.t(),
      description: String.t() | nil,
      notes: String.t() | nil
    }

    def parse(json) do
      %__MODULE__{
        id: json["queueId"],
        map: json["map"],
        description: json["description"],
        notes: json["notes"]
      }
    end

    def data() do
      Dataloader.KV.new(&fetch/2)
    end

    defp fetch(:by_id, args) do
      all_queues = GameConstants.queues()

      Enum.reduce(args, %{}, fn %{id: id} = arg, map ->
        Map.put(map, arg, Enum.find(all_queues, nil, fn %__MODULE__{id: id2} -> id2 == id end))
      end)
    end
end
