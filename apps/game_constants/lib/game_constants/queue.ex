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

    defp fetch({:by_id, %{id: id}}, %{}) do
      all_seasons = GameConstants.queues()

      %{%{} => Enum.find(all_seasons, nil, fn %__MODULE__{id: id2} -> id2 == id end)}
    end
end
