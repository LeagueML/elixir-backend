defmodule Ddragon.Skin do
  defstruct [:id, :num, :name, :chromas]

  @type t :: %__MODULE__{
    id: integer(),
    num: integer(),
    name: String.t(),
    chromas: boolean()
  }

  @spec parse(map()) :: t()
  def parse(json) do
    {id, ""} = Integer.parse(json["id"])
    %__MODULE__{
      id: id,
      num: json["num"],
      name: json["name"],
      chromas: json["chromas"]
    }
  end
end
