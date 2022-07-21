defmodule GraphQLApi.Schema do
  use Absinthe.Schema

  import_types ChampionV3.Schema

  query do
    import_fields :champion_v3_queries
  end
end
