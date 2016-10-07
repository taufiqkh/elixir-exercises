defmodule Stack.Supervisor do
  # Chapter 17 OTP Supervisors
  # Programming Elixir 1.2
  use Supervisor

  def start_link(max_len) do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [])
    start_workers(sup, max_len)
    result
  end

  def start_workers(sup, max_len) do
    # Start the stash worker
    {:ok, stash} =
      Supervisor.start_child(sup, worker(Stack.Stash, [{max_len, []}]))
    # and then the subsupervisor for the actual stack server
    Supervisor.start_child(sup, supervisor(Stack.SubSupervisor, [stash]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end

defmodule Stack.SubSupervisor do
  use Supervisor

  def start_link(stash_pid) do
  IO.puts("Stack supervisor: #{inspect stash_pid}")
    {:ok, _pid} = Supervisor.start_link(__MODULE__, stash_pid)
  end

  def init(stash_pid) do
    child_processes = [worker(StackServer, [stash_pid])]
    supervise child_processes, strategy: :one_for_one
  end
end

defmodule StackServer do
  @moduledoc false

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

defmodule Stack.Stash do
  use GenServer

  # External API
  def start_link(state) do
    IO.puts("Stack.Stash.init(#{inspect state})")
    {:ok, _pid} = GenServer.start_link(__MODULE__, state)
  end

  def save_value(pid, value) do
    GenServer.cast pid, {:save_value, value}
  end

  def get_value(pid) do
    GenServer.call pid, :get_value
  end

  # GenServer implementation
  def handle_call(:get_value, _from, current_value) do
    {:reply, current_value, current_value}
  end

  def handle_cast({:save_value, value}, _current_value) do
    {:noreply, value}
  end
end