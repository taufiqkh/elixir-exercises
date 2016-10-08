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