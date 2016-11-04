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
    [
      String.split(line, ",", trim: true) |> _autoconvert
      | _split_lines(rest)
    ]
  end

  defp _autoconvert([]) do
    []
  end
  defp _autoconvert([possible_float | rest]) do
    [_autoconvert(possible_float) | _autoconvert(rest)]
  end
  defp _autoconvert(possible_float) do
    case Float.parse(possible_float) do
      {float, ""} -> float
      _ -> possible_float
    end
  end
end