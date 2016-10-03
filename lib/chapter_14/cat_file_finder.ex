defmodule Chapter14.CatFileFinder do
  @moduledoc false

  def count_cats(<<>>, count) do
    count
  end
  def count_cats(<<?c, <<?a, <<?t, rest :: binary >> >> >>, count) do
    count_cats(rest, count + 1)
  end
  def count_cats(<<_, rest :: binary>>, count) do
    count_cats(rest, count)
  end
  def count_file_cats(path) do
    count_cats(File.read!(path), 0)
  end

  def cats(scheduler_pid) do
    send scheduler_pid, {:ready, self}
    receive do
      {:cats, path, client} ->
        send client, {:answer, path, count_file_cats(path), self}
        cats(client)
      {:shutdown} ->
        exit(:normal)
    end
  end
end