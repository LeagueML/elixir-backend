defmodule Region do
  @type t :: (
    :euw1
  | :br1
  | :eun1
  | :jp1
  | :kr
  | :la1
  | :la2
  | :na1
  | :oc1
  | :ru
  | :tr1
  )

  @all_regions [
      :euw1,
      :br1,
      :eun1,
      :jp1,
      :kr,
      :la1,
      :la2,
      :na1,
      :oc1,
      :ru,
      :tr1
    ]

  @spec all_regions() :: [t()]
  def all_regions(), do: @all_regions
end
