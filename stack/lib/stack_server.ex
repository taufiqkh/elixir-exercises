defmodule StackServer do
  @moduledoc false

  use GenServer

  def start_link(max_len) do
    GenServer.start_link(__MODULE__, {max_len, []}, name: :stack)
  end

  def pop do
    GenServer.call(:stack, :pop)
  end

  def push(elem) do
    GenServer.cast(:stack, {:push, elem})
  end

  def handle_call(:pop, _from_pid, {max_len, [head | rest]}) do
    {:reply, head, {max_len, rest}}
  end

  def handle_cast({:push, delta}, {max_len, list}) do
    if Enum.count(list) == max_len do
      System.halt(1)
    else
      {:noreply, {max_len, [delta | list]}}
    end
  end

  def terminate(reason, state) do
    IO.puts "Terminating because #{inspect reason}, state: #{inspect state}"
  end
end