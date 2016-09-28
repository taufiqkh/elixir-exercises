defmodule StringsAndBinaries do
  @moduledoc false

  @upperOffset ?A - ?a
  def _capitalise(<<?. :: utf8, <<?\s :: utf8, <<head :: utf8, rest :: binary >> >> >>) when head >= ?A and head <= ?z do
    newHead = if head >= ?a and head <= ?z do
      head + @upperOffset
    else
      head
    end
    <<?., <<?\s, <<newHead :: utf8, _capitalise(rest) :: binary >> >> >>
  end
  def _capitalise(<<>>), do: <<>>
  def _capitalise(<<head :: utf8, rest :: binary>>) when head >= ?A and head <= ?Z do
    <<head - @upperOffset, _capitalise(rest) :: binary>>
  end
  def _capitalise(<<head :: utf8, rest :: binary>>), do: <<head, _capitalise(rest) :: binary>>

  def capitalize_sentences(<<head :: utf8, rest :: binary>>) when head >= ?a and head <= ?z do
    <<head + @upperOffset, _capitalise(rest) :: binary >>
  end
  def capitalize_sentences(str), do: _capitalise(str)

  def _read_by_line(_file, :eof), do: []
  def _read_by_line(_file, {:error, reason}) do
    IO.puts reason
    []
  end
  def _read_by_line(file, data) do
    [id, ship_to, net_amount] = String.split(String.trim(data), ",")
    [[id: id, ship_to: ship_to, net_amount: String.to_float(net_amount)] | _read_by_line(file, IO.read(file, :line))]
  end
  def _read(file) do
    IO.read(file, :line)
    _read_by_line(file, IO.read(file, :line))
  end
  def file_read() do
    File.open("data.txt", [:read], &_read/1)
  end

  def printable?([]), do: true
  def printable?([head | tail]), do: (head >= ?\s and head <= ?~ and printable?(tail))

  def _longest([], max), do: max
  def _longest([head | tail], max) do
    if String.length(head) > max do
      _longest(tail, String.length(head))
    else
      _longest(tail, max)
    end
  end
  def _lpad(str, longest) do
    length = String.length(str) + div(longest - String.length(str), 2)
    String.rjust(str, length, ?\s)
  end
  def _center([], _), do: :ok
  def _center([str | rest], longest) do
    IO.puts(_lpad(str, longest))
    _center(rest, longest)
  end
  def center([]), do: IO.puts("")
  def center(strs) do
    longest = _longest(strs, 0)
    _center(strs, longest)
  end

  defp _as_number([], num), do: num
  defp _as_number([head | tail], num), do: _as_number(tail, num * 10 + head - ?0)
  defp _as_number(str), do: _as_number(str, 0)
  defp _calculate([head | tail], num) when head == ?+ do
    num + _as_number(tail)
  end
  defp _calculate([head | tail], num) when head == ?- do
    num - _as_number(tail)
  end
  defp _calculate([head | tail], num) when head == ?* do
    num * _as_number(tail)
  end
  defp _calculate([head | tail], num) when head == ?/ do
    num / _as_number(tail)
  end

  defp _calculate([head | tail], num) do
    _calculate(tail, num * 10 + head - ?0)
  end
  def calculate(list), do: _calculate(list, 0)

  defp take_char(_, []), do: {false, []}
  defp take_char(ch, [head | tail]) do
    if (ch == head) do
      {true, tail}
    else
      {taken, remain} = take_char(ch, tail)
      if (taken) do
        {true, [head | remain]}
      else
        {taken, []}
      end
    end
  end

  def anagram?([], []), do: true
  def anagram?(_, []), do: false
  def anagram?([], _), do: false
  def anagram?([head | tail], str) do
    {taken, remain} = take_char(head, str)
    if (taken) do
      anagram?(tail, remain)
    else
      false
    end
  end
end