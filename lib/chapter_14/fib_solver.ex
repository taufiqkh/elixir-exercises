defmodule Chapter14.FibSolver do
  # Working with multiple processes, chapter 14, exercise 8
  # Programming Elixir, Dave Thomas
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
end