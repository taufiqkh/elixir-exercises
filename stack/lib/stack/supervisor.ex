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