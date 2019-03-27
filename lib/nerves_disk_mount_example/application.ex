defmodule NervesDiskMountExample.Application do
  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: NervesDiskMountExample.Supervisor]
    Supervisor.start_link([NervesDiskMountExample.Worker], opts)
  end
end
