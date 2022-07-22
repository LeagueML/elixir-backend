defmodule Ddragon.Passive do
  defstruct [:name, :description, :image]

  @type t :: %__MODULE__{
    name: String.t(),
    description: String.t(),
    image: Ddragon.Image.t()
  }

  @spec parse(map()) :: t()
  def parse(json) do
    %__MODULE__{
      name: json["name"],
      description: json["description"],
      image: Ddragon.Image.parse(json["image"])
    }
  end
end
