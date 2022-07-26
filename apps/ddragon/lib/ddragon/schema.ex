defmodule Ddragon.Schema do

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  object :version do
    field :major, non_null(:integer)
    field :minor, non_null(:integer)
    field :patch, non_null(:integer)
    field :revision, :integer
    field :version_string, non_null(:string) do
      resolve fn parent, %{}, _ ->
        {:ok, Ddragon.Version.version_string(parent)}
      end
    end
  end

  connection node_type: :version

  object :image do
    field :full, non_null(:string)
    field :sprite, non_null(:string)
    field :group, non_null(:string)
    field :x, non_null(:integer)
    field :y, non_null(:integer)
    field :width, non_null(:integer)
    field :height, non_null(:integer)
  end

  object :champion_passive do
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :image, non_null(:image)
  end

  object :skin do
    field :id, non_null(:integer)
    field :num, non_null(:integer)
    field :name, non_null(:string)
    field :chromas, :boolean
  end

  connection node_type: :skin

  object :champion_info do
    field :attack, non_null(:integer)
    field :defense, non_null(:integer)
    field :magic, non_null(:integer)
    field :difficulty, non_null(:integer)
  end

  object :champion_stats do
    field :hp, non_null(:float)
    field :hp_per_level, non_null(:float)
    field :mp, non_null(:float)
    field :mp_per_level, non_null(:float)
    field :movespeed, non_null(:float)
    field :armor, non_null(:float)
    field :armor_per_level, non_null(:float)
    field :spellblock, non_null(:float)
    field :spellblock_per_level, non_null(:float)
    field :attackrange, non_null(:float)
    field :hp_regen, non_null(:float)
    field :hp_regen_per_level, non_null(:float)
    field :mp_regen, non_null(:float)
    field :mp_regen_per_level, non_null(:float)
    field :crit, non_null(:float)
    field :crit_per_level, non_null(:float)
    field :attack_damage, non_null(:float)
    field :attack_damage_per_level, non_null(:float)
    field :attackspeed, non_null(:float)
    field :attackspeed_per_level, non_null(:float)
  end

  node object :champion do
    field :key, non_null(:integer)
    field :name, non_null(:string)
    field :title, non_null(:string)
    field :info, non_null(:champion_info)
    field :image, non_null(:image)
    connection field :skins, node_type: :skin do
      resolve fn pagination_args, %{source: %{skins: skins}} ->
        Absinthe.Relay.Connection.from_list(skins, pagination_args)
      end
    end
    field :lore, non_null(:string)
    field :ally_tips, non_null(list_of(non_null(:string)))
    field :enemy_tips, non_null(list_of(non_null(:string)))
    field :tags, non_null(list_of(non_null(:string)))
    field :partype, non_null(:string)
    field :stats, non_null(:champion_stats)
    # TODO: Spells
    # field :spells [Ddragon.Spell],
    field :passive, non_null(:champion_passive)
  end

  connection node_type: :champion

  object :ddragon_queries do
    connection field :versions, node_type: :version do
      resolve fn pagination_args, _ ->
        Absinthe.Relay.Connection.from_list(Ddragon.versions(), pagination_args)
      end
    end

    field :latest_version, :version do
      resolve fn _, _ ->
        [latest | _] = Ddragon.versions()
        {:ok, latest}
      end
    end

    field :champion_by_id, :champion do
      arg :version, non_null(:string)
      arg :id, non_null(:string)
      resolve fn _parent, args, %{context: %{loader: loader}} ->
        values = [args]
        loader
        |> Dataloader.load_many(Ddragon.Champion, :by_id, values)
        |> on_load(fn loader ->
          results = Dataloader.get_many(loader, Ddragon.Champion, :by_id, values)
          {:ok, results |> Enum.at(0)}
        end)
      end
    end

    connection field :champions, node_type: :champion do
      arg :version, non_null(:string)
      resolve fn %{version: version} = pagination_args, %{context: %{loader: loader}} ->
        {:ok, pagination_direction, limit} = Absinthe.Relay.Connection.limit(pagination_args)
        {:ok, offset} = Absinthe.Relay.Connection.offset(pagination_args)
        data = Ddragon.champion_list(version)
        absolute_offset = case {offset, pagination_direction} do
          {nil, :forward} -> 0
          {:nil, :backward} -> length(data) - limit
          {offset, :forward} -> offset
          {offset, :backward} -> length(data) - limit - offset
        end

        values = Ddragon.champion_list(version)
        |> Enum.drop(absolute_offset)
        |> Enum.take(limit)
        |> Enum.map(fn %{id: id} -> %{version: version, id: id} end)
        loader
        |> Dataloader.load_many(Ddragon.Champion, :by_id, values)
        |> on_load(fn loader ->
          results = Dataloader.get_many(loader, Ddragon.Champion, :by_id, values)
          Absinthe.Relay.Connection.from_slice(results, offset)
        end)
      end
    end
  end
end
