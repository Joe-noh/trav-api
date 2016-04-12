defmodule Trav do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Trav.Endpoint, []),
      supervisor(Trav.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Trav.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Trav.Endpoint.config_change(changed, removed)
    :ok
  end
end
