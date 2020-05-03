defmodule BarometerTest do
  use ExUnit.Case
  doctest Barometer

  test "greets the world" do
    assert Barometer.hello() == :world
  end
end
