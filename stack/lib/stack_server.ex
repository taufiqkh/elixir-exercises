defmodule StackServer do
  @moduledoc false

  @vsn "0"

  use GenServer

  def start_link(stash_pid) do
    GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(elem) do
    GenServer.cast(__MODULE__, {:push, elem})
  end

  # GenServer implementation
  def init(stash_pid) do
    state = Stack.Stash.get_value stash_pid
    {:ok, {state , stash_pid}}
  end

  def handle_call(:pop, _from_pid, {{max_len, [head | rest]}, stash_pid}) do
    {:reply, head, {{max_len, rest}, stash_pid}}
  end

  def handle_cast({:push, delta}, {{max_len, list}, stash_pid}) do
    if Enum.count(list) == max_len do
      System.halt(1)
    else
      {:noreply, {{max_len, [delta | list]}, stash_pid}}
    end
  end

  def terminate(reason, {state, stash_pid}) do
    Stack.Stash.save_value stash_pid, state
    IO.puts "Terminating because #{inspect reason}, state: #{inspect state}"
  end
end