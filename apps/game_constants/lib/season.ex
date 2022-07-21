  defmodule GameConstants.Season do
    defstruct [:id, :name]

    @type t :: %__MODULE__{
      id: integer(),
      name: String.t()
    }

    def parse(json) do
      %__MODULE__{
        id: json["id"],
        name: json["season"]
      }
    end

    def data() do
      Dataloader.KV.new(&fetch/2)
    end

    defp fetch({:by_id, %{id: id}}, %{}) do
      all_seasons = GameConstants.seasons()

      %{%{} => Enum.find(all_seasons, nil, fn %__MODULE__{id: id2} -> id2 == id end)}
    end

    defp fetch({:by_name, %{name: name}}, %{}) do
      all_seasons = GameConstants.seasons()

      %{%{} => Enum.find(all_seasons, nil, fn %__MODULE__{name: name2} -> name2 == name end)}
    end
  end
