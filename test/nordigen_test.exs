defmodule NordigenTest do
  use ExUnit.Case
  doctest Nordigen

  test "greets the world" do
    assert Nordigen.hello() == :world
  end
end
