defmodule GameConstants.Schema do

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  node object :season do
    field :name, non_null(:string)
  end

  connection node_type: :season

  node object :queue do
    field :map, non_null(:string)
    field :description, :string
    field :notes, :string
  end

  connection node_type: :queue

  node object :map do
    field :name, non_null(:string)
    field :notes, :string
  end

  connection node_type: :map

  object :game_mode do
    field :name, non_null(:string)
    field :description, :string
  end

  connection node_type: :game_mode

  object :game_constants_queries do
    connection field :seasons, node_type: :season do
      resolve fn pagination_args, _ ->
        Absinthe.Relay.Connection.from_list(GameConstants.seasons(), pagination_args)
      end
    end

    field :season_by_id, :season do
      arg :id, non_null(:integer)
      resolve fn _parent, args, %{context: %{loader: loader}} ->
        values = [args]
        loader
        |> Dataloader.load_many(GameConstants.Season, :by_id, values)
        |> on_load(fn loader ->
          results = Dataloader.get_many(loader, GameConstants.Season, :by_id, values)
          {:ok, results |> Enum.at(0)}
        end)
      end
    end

    field :season_by_name, :season do
      arg :id, non_null(:integer)
      resolve fn _parent, args, %{context: %{loader: loader}} ->
        values = [args]
        loader
        |> Dataloader.load_many(GameConstants.Season, :by_name, values)
        |> on_load(fn loader ->
          results = Dataloader.get_many(loader, GameConstants.Season, :by_name, values)
          {:ok, results |> Enum.at(0)}
        end)
      end
    end

    connection field :queues, node_type: :queue do
      resolve fn pagination_args, _ ->
        Absinthe.Relay.Connection.from_list(GameConstants.queues(), pagination_args)
      end
    end

    field :queue_by_id, :queue do
      arg :id, non_null(:integer)
      resolve fn _parent, args, %{context: %{loader: loader}} ->
        values = [args]
        loader
        |> Dataloader.load_many(GameConstants.Queue, :by_id, values)
        |> on_load(fn loader ->
          results = Dataloader.get_many(loader, GameConstants.Queue, :by_id, values)
          {:ok, results |> Enum.at(0)}
        end)
      end
    end

    connection field :maps, node_type: :map do
      resolve fn pagination_args, _ ->
        Absinthe.Relay.Connection.from_list(GameConstants.maps(), pagination_args)
      end
    end

    field :map_by_id, :map do
      arg :id, non_null(:integer)
      resolve fn _parent, args, %{context: %{loader: loader}} ->
        values = [args]
        loader
        |> Dataloader.load_many(GameConstants.Map, :by_id, values)
        |> on_load(fn loader ->
          results = Dataloader.get_many(loader, GameConstants.Map, :by_id, values)
          {:ok, results  |> Enum.at(0)}
        end)
      end
    end

    connection field :game_modes, node_type: :game_mode do
      resolve fn pagination_args, _ ->
        Absinthe.Relay.Connection.from_list(GameConstants.game_modes(), pagination_args)
      end
    end

    field :game_mode_by_name, :game_mode do
      arg :name, non_null(:string)
      resolve fn _parent, args, %{context: %{loader: loader}} ->
        values = [args]
        loader
        |> Dataloader.load_many(GameConstants.GameMode, :by_name, values)
        |> on_load(fn loader ->
          results = Dataloader.get_many(loader, GameConstants.GameMode, :by_name, values)
          {:ok, results |> Enum.at(0)}
        end)
      end
    end
  end
end
