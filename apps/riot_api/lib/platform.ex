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

  @spec parse(String.t()) :: {:ok, t()} | :error
  def parse(value) do
    case Enum.find(@all_platforms, nil, fn a -> Atom.to_string(a) == value end) do
      nil -> :error
      val -> {:ok, val}
    end
  end
end
