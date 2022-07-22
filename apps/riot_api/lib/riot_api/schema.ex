defmodule RiotApi.Schema do
  use Absinthe.Schema.Notation

  scalar :region do
    serialize &serialize_region/1
    parse &parse_region/1
  end

  @spec serialize_region(RiotApi.Region.t()) :: String.t()
  def serialize_region(value), do: Atom.to_string(value)

  @spec parse_region(Absinthe.Blueprint.Input.String.t) :: {:ok, RiotApi.Region.t()} | :error
  @spec parse_region(Absinthe.Blueprint.Input.Null.t) :: {:ok, nil}
  defp parse_region(%Absinthe.Blueprint.Input.String{value: value}) do
    case RiotApi.Region.parse(value) do
      {:ok, result} -> {:ok, result}
      _ -> {:error}
    end
  end
  defp parse_region(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end
  defp parse_region(_) do
    :error
  end

  scalar :platform do
    serialize &serialize_platform/1
    parse &parse_platform/1
  end

  @spec serialize_platform(RiotApi.Platform.t()) :: String.t()
  def serialize_platform(value), do: Atom.to_string(value)

  @spec parse_platform(Absinthe.Blueprint.Input.String.t) :: {:ok, RiotApi.Platform.t()} | :error
  @spec parse_platform(Absinthe.Blueprint.Input.Null.t) :: {:ok, nil}
  defp parse_platform(%Absinthe.Blueprint.Input.String{value: value}) do
    case RiotApi.Platform.parse(value) do
      {:ok, result} -> {:ok, result}
      _ -> {:error}
    end
  end
  defp parse_platform(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_platform(_) do
    :error
  end
end
