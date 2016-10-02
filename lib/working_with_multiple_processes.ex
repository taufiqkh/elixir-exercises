defmodule WorkingWithMultipleProcesses do
  @moduledoc false

  def pmap(collection, fun) do
    me = self
    collection
    |> Enum.map(fn (elem) ->
        spawn_link fn -> (send me, {self, fun.(elem)}) end
      end)
    |> Enum.map(fn (pid) ->
        receive do
          {^pid, result} -> result
        end
      end)
  end

  def run6(n) do
    pmap(1..n, &(&1 + 1))
  end
  def send_done(sender) do
    send sender, :ok
    exit(:done)
  end

  def run3() do
    spawn_monitor(WorkingWithMultipleProcesses, :send_done, [self])
    :timer.sleep(500)
    receive do
      token ->
        IO.puts "Token received: #{token}"
    end
  end

  def await(sender, token) do
    receive do
      ^token -> send sender, token
    end
  end
  def run2() do
    fred = spawn(WorkingWithMultipleProcesses, :await, [self, "Fred"])
    betty = spawn(WorkingWithMultipleProcesses, :await, [self, "Betty"])
    send fred, "Fred"
    send betty, "Betty"
    receive do
      n ->
        IO.puts "#{n}"
    end

    receive do
      n ->
        IO.puts "#{n}"
    end
  end

  # Example exercise 1: Chain
  def counter(next_pid) do
    receive do
      n ->
        send next_pid, n + 1
    end
  end

  def create_processes(n) do
    last = Enum.reduce 1..n, self,
      fn (_, send_to) ->
        spawn(WorkingWithMultipleProcesses, :counter, [send_to])
      end
    send last, 0

    receive do
      final_answer when is_integer(final_answer) ->
        "Result is #{inspect final_answer}"
    end
  end

  def runChain(n) do
    IO.puts inspect :timer.tc(WorkingWithMultipleProcesses, :create_processes, [n])
  end

end