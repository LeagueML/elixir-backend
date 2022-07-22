defmodule GameConstants.Schema do

  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  object :season do
    field :id, non_null(:integer)
    field :name, non_null(:string)
  end

  object :queue do
    field :id, non_null(:integer)
    field :map, non_null(:string)
    field :description, :string
    field :notes, :string
  end

  object :map do
    field :id, non_null(:integer)
    field :name, non_null(:string)
    field :notes, :string
  end

  object :game_mode do
    field :name, non_null(:string)
    field :description, :string
  end

  object :game_constants_queries do
    field :seasons, list_of(:season) do
      resolve fn _, _ ->
        {:ok, GameConstants.seasons()}
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

    field :queues, list_of(:queue) do
      resolve fn _, _ ->
        {:ok, GameConstants.queues()}
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

    field :maps, list_of(:map) do
      resolve fn _, _ ->
        {:ok, GameConstants.maps()}
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

    field :game_modes, list_of(:game_mode) do
      resolve fn _, _ ->
        {:ok, GameConstants.game_modes()}
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
