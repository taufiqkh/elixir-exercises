defmodule StackServerTest do
  use ExUnit.Case
  doctest StackServer

  test "Handle push" do
    item = "test"
    assert {:noreply, {{5, [item]}, self}} == StackServer.handle_cast({:push, item}, {{5, []}, self})
  end

  test "Handle pop" do
    item = "test"
    state = {{5, [item]}, self}
    assert {:reply, item, {{5, []}, self}} == StackServer.handle_call(:pop, self, state)
  end
end