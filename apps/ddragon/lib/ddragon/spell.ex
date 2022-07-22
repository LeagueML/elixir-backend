defmodule Ddragon.Spell do
  # TODO: Parse & Expose Spell Data
  defstruct []

  @type t :: %__MODULE__{}

  @spec parse(map()) :: t()
  def parse(_json) do
    %__MODULE__{}
  end
end
