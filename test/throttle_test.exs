defmodule ThrottleTest do
  use ExUnit.Case
  doctest Throttle

  test "greets the world" do
    assert Throttle.hello() == :world
  end
end
