defmodule RiotApi.Region do
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

  @spec parse(String.t()) :: {:ok, t()} | :error
  def parse(value) do
    case Enum.find(@all_regions, nil, fn a -> Atom.to_string(a) == value end) do
      nil -> :error
      val -> {:ok, val}
    end
  end
end
