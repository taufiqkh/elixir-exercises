defmodule Sigils do
  @doc """
    Parses multiple lines of comma-separated data, returning a list where each element is a row of data and each row is
    a list of values. Assumes data is well-formed, comma separated.

    ## Example Usage:
    iex> ~v\"""
    ...> Item,Qty,Price
    ...> foo,1,2
    ...> bar,5.6,3.14
    ...> baz,7.5,8
    ...> \"""
    [[Item: "foo", Qty: 1.0, Price: 2.0], [Item: "bar", Qty: 5.6, Price: 3.14], [Item: "baz", Qty: 7.5, Price: 8.0]]
  """
  def sigil_v(lines, _opts) do
    lines |>
      String.trim |>
      String.split("\n", trim: true) |>
      _split_header_lines
  end

  defp _split_header_lines([]) do
    []
  end
  defp _split_header_lines([header_line | rest]) do
    _split(header_line) |> _split_lines(rest)
  end

  defp _split(line) do
    String.split(line, ",", trim: true)
  end

  defp _split_lines(headers, []) do
    []
  end
  defp _split_lines(headers, [line | rest] ) do
    [
      _head_line(headers, _split(line) |> _autoconvert)
      | _split_lines(headers, rest)
    ]
  end
  defp _head_line([], []) do
    []
  end
  defp _head_line([header | headers], [entry | rest]) do
    [{String.to_atom(header), entry} | _head_line(headers, rest)]
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