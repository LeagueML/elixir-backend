defmodule GameConstants.Schema do

  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

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

  object :game_constants_queries do
    field :seasons, list_of(:season) do
      resolve fn _, _ ->
        {:ok, GameConstants.seasons()}
      end
    end

    field :season_by_id, :season do
      arg :id, non_null(:integer)
      resolve dataloader(GameConstants.Season, :by_id)
    end

    field :season_by_name, :season do
      arg :id, non_null(:integer)
      resolve dataloader(GameConstants.Season, :by_name)
    end

    field :queues, list_of(:queue) do
      resolve fn _, _ ->
        {:ok, GameConstants.queues()}
      end
    end

    field :queue_by_id, :queue do
      arg :id, non_null(:integer)
      resolve dataloader(GameConstants.Queue, :by_id)
    end
  end
end
