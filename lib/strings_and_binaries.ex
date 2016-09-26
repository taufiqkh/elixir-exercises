defmodule StringsAndBinaries do
  @moduledoc false

  def printable?([]), do: true
  def printable?([head | tail]), do: (head >= ?\s and head <= ?~ and printable?(tail))

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