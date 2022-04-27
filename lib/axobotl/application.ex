defmodule Axobotl.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Axobotl.Consumer
    ]

    opts = [strategy: :one_for_one, name: Axobotl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end