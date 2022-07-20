defmodule RiotRegion do
  use Supervisor

  def start_link(region) do
    Supervisor.start_link(__MODULE__, {region})
  end

  @impl true
  def init({region}) do
    children = [
        {Finch,
          name: Atom.to_string(region) <> "_FinchPool",
          pools: %{
            RiotClient.get_base_url(region) => [protocol: :http2, size: 1, count: 4],
          }
        }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
