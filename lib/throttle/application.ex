defmodule Throttle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do

    children = [
      {Roulette, [role: :both]},
      {Riverside, [handler: Throttle.Handler]}
    ]

    opts = [strategy: :one_for_one, name: Throttle.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
