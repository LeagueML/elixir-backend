defmodule RiotApi.Platform do
  @type t :: (
    :europe
  | :americas
  | :asia
  | :sea
  )

  @all_platforms [
      :europe,
      :americas,
      :asia,
      :sea
    ]

  @spec all_platforms() :: [t()]
  def all_platforms(), do: @all_platforms
end
