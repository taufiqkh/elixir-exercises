defmodule RRTicker do
  # Round-robin implementation of the ticker. Exercise 4, chapter 15 Nodes, Programming Elixir 1.2
  @moduledoc false

  @interval 2_000
  @name :ticker

  def start do
    spawn(__MODULE__, :register, [])
  end

  def register do
    case :global.whereis_name(@name) do
      :undefined ->
        if :global.register_name(@name, self) do
          generator()
        else
          register()
        end
      pid ->
        IO.puts("#{inspect self} registering...")
        send pid, {:register, self}
        receive do
          {:await, next} -> await(next)
        end
    end
  end

  def generator() do
    IO.puts("New circle started by #{inspect self}")
    receive do
      {:register, pid} ->
        send pid, {:await, self}
        generator(pid)
    end
  end

  def generator(next) do
    IO.puts("#{inspect self} generating tick")
    receive do
      {:register, pid} -> link pid, next, fn -> generator(pid) end
    after @interval ->
      send next, {:tick}
      await(next)
    end
  end

  def await(next) do
    IO.puts("#{inspect self} awaiting tick")
    receive do
      {:tick} ->
        IO.puts("client tick #{inspect self}")
        generator(next)
      {:register, pid} -> link pid, next, fn -> await(pid) end
    end
  end

  def link(newNext, oldNext, thenFunc) do
    send newNext, {:await, oldNext}
    thenFunc.()
  end
end