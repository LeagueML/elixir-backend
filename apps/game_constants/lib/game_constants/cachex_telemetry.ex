defmodule Cachex.Telemetry do
  use Cachex.Hook

  def init(_), do: {:ok, nil}

  def handle_notify({:fetch, _}, {:commit, _}, nil) do
    :telemetry.execute([:cachex, :fetch, :commit], %{})

    {:ok, nil}
  end

  def handle_notify({:fetch, _}, {:ok, _}, nil) do
    :telemetry.execute([:cachex, :fetch, :ok], %{})

    {:ok, nil}
  end

  def handle_notify(_, _, nil), do: {:ok, nil}
end
