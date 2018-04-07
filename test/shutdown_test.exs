defmodule ShutdownTest do
  use ExUnit.Case
  doctest Shutdown

  test "greets the world" do
    assert Shutdown.hello() == :world
  end
end
