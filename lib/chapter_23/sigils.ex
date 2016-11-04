defmodule Sigils do
  @doc """
    Parses multiple lines of comma-separated data, returning a list where each element is a row of data and each row is
    a list of values. Assumes data is well-formed, comma separated.

    ## Example Usage:
    iex> ~v\"""
    ...> 1,2
    ...> test,bar,foo
    ...> \"""
    [["1", "2", "3"], ["test", "bar", "foo"]]
  """
  def sigil_v(lines, _opts) do
    lines |> String.trim |> String.split("\n", trim: true) |> _split_lines
  end

  defp _split_lines([]) do
    []
  end
  defp _split_lines([line | rest] ) do
    [String.split(line, ",", trim: true) | _split_lines(rest)]
  end
end