defmodule GameConstants.Schema do

  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  object :season do
    field :id, :integer
    field :name, :string
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
  end
end
