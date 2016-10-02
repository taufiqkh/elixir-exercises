defmodule FibSolver do
  # Working with multiple processes, chapter 14, exercise 8
  @moduledoc false

  def fib(scheduler) do
    send scheduler, {:ready, self}
    receive do
      {:fib, n, client} ->
        send client, {:answer, n, calc_fib(n), self}
        fib(client)
      {:shutdown} ->
        exit(:normal)
    end
  end

  # very inefficient, deliberately
  def calc_fib(0), do: 0
  def calc_fib(1), do: 1
  def calc_fib(n), do: calc_fib(n - 1) + calc_fib(n - 2)

  def run(num_processes, module, func, to_calculate) do
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self]) end)
    |> schedule_processes(to_calculate, [])
  end

  def schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [ next | tail ] = queue
        send pid, {:fib, next, self}
        schedule_processes(processes, tail, results)
      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end
      {:answer, n, answer, _pid} ->
        schedule_processes(processes, queue, [{n, answer} | results])
    end
  end

  def run_sample do
    to_process = [37, 37, 37, 37, 37, 37, 37, 37]
    Enum.each 1..10, fn (num_processes) ->
      {time, result} = :timer.tc(
        FibSolver, :run, [num_processes, FibSolver, :fib, to_process]
      )

      if num_processes == 1 do
        IO.puts inspect result
        IO.puts "|n #    time (s)"
      end
      :io.format "~2B      ~.2f~n", [num_processes, time / 1000000.0]
    end
  end
end