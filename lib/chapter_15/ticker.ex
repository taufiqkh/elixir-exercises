defmodule Chapter15.Ticker do
  # Exercises for chapter 15: Nodes, exercises 2-3
  # Programming Elixir 1.2
  @moduledoc false

  @interval 2_000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], []])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), {:register, client_pid}
  end

  def stop do
    send :global.whereis_name(@name), {:shutdown}
  end

  def generator(clients, queue) do
    receive do
      {:register, client_pid} ->
        IO.puts "registering #{inspect client_pid}"
        generator([client_pid | clients], queue)
      {:shutdown} ->
        Enum.each clients, fn client ->
          send client, {:tock}
        end
        exit(:done)
    after
      @interval ->
        IO.puts "tick"
        if clients == [] do
          generator(clients, queue)
        else
          [client | rest ] = case queue do
            [] -> clients
            _ -> queue
          end
          send client, {:tick}
          generator(clients, rest)
        end
    end
  end
end

defmodule Chapter15.TickClient do
  @moduledoc false
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    {pid, Chapter15.Ticker.register(pid)}
  end

  def receiver do
    receive do
      {:tick} ->
        IO.puts "client tick"
        receiver
      {:tock} ->
        IO.puts "client tock"
        exit(:done)
    after 60_000 ->
      IO.puts "Timeout"
      exit(:timeout)
    end
  end
end