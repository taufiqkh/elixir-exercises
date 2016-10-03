defmodule Chapter14.Scheduler do
  @moduledoc false

  def run(num_processes, module, func, to_calculate) do
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self]) end)
    |> schedule_processes(func, to_calculate, [])
  end

  def schedule_processes(processes, func, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [ next | tail ] = queue
        send pid, {func, next, self}
        schedule_processes(processes, func, tail, results)
      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), func, queue, results)
        else
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end
      {:answer, n, answer, _pid} ->
        schedule_processes(processes, func, queue, [{n, answer} | results])
    end
  end

  def run_processes(to_process, module, func, max_processes \\ 10) do
    Enum.each 1..max_processes, fn (num_processes) ->
      {time, result} = :timer.tc(
        Chapter14.Scheduler, :run, [num_processes, module, func, to_process]
      )

      if num_processes == 1 do
        IO.puts inspect result
        IO.puts "|n #    time (s)"
      end
      :io.format "~2B      ~.2f~n", [num_processes, time / 1000000.0]
    end
  end
  def run_sample do
    to_process = [37, 37, 37, 37, 37, 37, 37, 37]
    run_processes(to_process, Chapter14.FibSolver, :fib)
  end

  def cats_files(unexpandedDir) do
    dir = Path.expand(unexpandedDir)
    dir
    |> File.ls!
    |> Enum.map(&(Path.join(dir, &1)))
    |> Enum.filter(&(!File.dir?(&1)))
  end
  def run_cats do
    "."
    |> cats_files
    |> run_processes(Chapter14.CatFileFinder, :cats)
  end
end