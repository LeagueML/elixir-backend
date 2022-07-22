defmodule Ddragon.Schema do

  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  object :version do
    field :major, non_null(:integer)
    field :minor, non_null(:integer)
    field :patch, non_null(:integer)
    field :revision, :integer
  end

  object :ddragon_queries do
    field :versions, list_of(:version) do
      resolve fn _, _ ->
        {:ok, Ddragon.versions()}
      end
    end

    field :latest_version, :version do
      resolve fn _, _ ->
        [latest | _] = Ddragon.versions()
        {:ok, latest}
      end
    end
  end
end
