defmodule Ddragon.Image do
  defstruct [:full, :sprite, :group, :x, :y, :width, :height]

  @type t :: %__MODULE__{
    full: String.t(),
    sprite: String.t(),
    group: String.t(),
    x: integer(),
    y: integer(),
    width: integer(),
    height: integer()
  }

  @spec parse(map()) :: t()
  def parse(json) do
    %__MODULE__{
      full: json["full"],
      sprite: json["sprite"],
      group: json["group"],
      x: json["x"],
      y: json["y"],
      width: json["w"],
      height: json["h"],
    }
  end
end
