# Barometer

This is an exercise apps for Elixir Embedded using Nerves Project. My hardware is Raspberry Pi Zero and Pimoroni Enviro PHAT (https://shop.pimoroni.com/products/enviro-phat).
Build using Nerves 1.6, Elixir ALE 1.2 , and Elixir 1.10.3.

Guideline for this app is based on Elixir Conf 2017 by Frank Hunleth.

Later on, i'll try to continue to be able accessing on all sensors within Envirophat, and perhaps make an IoT based environment data gatherer for my home.cd

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app:
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
