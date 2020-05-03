defmodule Barometer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    #import Supervisor.Spec

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Barometer.Supervisor]
    children =
      [
        # Children for all targets
        # Starts a worker by calling: Barometer.Worker.start_link(arg)
        # {Barometer.Worker, arg},
        #worker(ElixirALE.I2C, ["i2c-1", 0x77, [name: Barometer.I2C]])
        %{
          id: Barometer.I2C,
          start: {ElixirALE.I2C, :start_link, ["i2c-1", 0x77, [name: Barometer.I2C]]}
        }
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: Barometer.Worker.start_link(arg)
      # {Barometer.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: Barometer.Worker.start_link(arg)
      # {Barometer.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:barometer, :target)
  end
end
