defmodule StackServer do
  @moduledoc false

  use GenServer

  def handle_call(:pop, _from_pid, [head | rest]) do
    {:reply, head, rest}
  end
end