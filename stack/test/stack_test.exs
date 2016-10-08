defmodule StackTest do
  use ExUnit.Case
  doctest Stack

  test "push and pop" do
    item = 58
    StackServer.push(item)
    assert item == StackServer.pop
  end
end
