defmodule Ddragon.Champion do
    defstruct [
      :id,
      :key,
      :name,
      :title,
      :info,
      :image,
      :skins,
      :lore,
      :ally_tips,
      :enemy_tips,
      :tags,
      :partype,
      :stats,
      :spells,
      :passive
    ]

    @type t :: %__MODULE__{
      id: String.t(),
      key: integer(),
      name: String.t(),
      title: String.t(),
      info: Info.t(),
      image: Ddragon.Image.t(),
      skins: [Ddragon.Skin.t()],
      lore: String.t(),
      ally_tips: [String.t()],
      enemy_tips: [String.t()],
      tags: [String.t()],
      partype: String.t(),
      stats: Ddragon.Stats.t(),
      spells: [Ddragon.Spell],
      passive: Ddragon.Passive
    }

    defmodule Info do
      defstruct [:attack, :defense, :magic, :difficulty]

      @type t :: %__MODULE__{
        attack: integer(),
        defense: integer(),
        magic: integer(),
        difficulty: integer()
      }

      @spec parse(map()) :: t()
      def parse(json) do
        %__MODULE__{
          attack: json["attack"],
          defense: json["defense"],
          magic: json["magic"],
          difficulty: json["difficulty"]
        }
      end
    end


    def parse(json) do
      {key, ""} = Integer.parse(json["key"])
      %__MODULE__{
        id: json["id"],
        key: key,
        name: json["name"],
        title: json["title"],
        info: Info.parse(json["info"]),
        image: Ddragon.Image.parse(json["image"]),
        skins: json["skins"] |> Enum.map(&Ddragon.Skin.parse/1),
        lore: json["lore"],
        ally_tips: json["allytips"],
        enemy_tips: json["enemytips"],
        tags: json["tags"],
        partype: json["partype"],
        stats: Ddragon.Stats.parse(json["stats"]),
        spells: json["spells"] |> Enum.map(&Ddragon.Spell.parse/1),
        passive: Ddragon.Passive.parse(json["passive"])
      }
    end

    def data() do
      Dataloader.KV.new(&fetch/2)
    end

    defp fetch(:by_name, args) do
      Enum.reduce(args, %{}, fn %{version: version, name: name} = arg, map ->
        Map.put(map, arg, Ddragon.champion_by_name(version, name))
      end)
    end
end
