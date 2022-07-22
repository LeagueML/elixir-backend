defmodule Cachex.Telemetry do
  use Cachex.Hook

  def init(state), do: {:ok, state}

  def handle_notify({:fetch, _}, {:commit, _}, state = {name}) do
    :telemetry.execute([:cachex, :fetch, :commit], %{name: name})

    {:ok, state}
  end

  def handle_notify({:fetch, _}, {:ok, _}, state = {name}) do
    :telemetry.execute([:cachex, :fetch, :ok], %{name: name})

    {:ok, state}
  end

  def handle_notify(_, _, state), do: {:ok, state}
end
