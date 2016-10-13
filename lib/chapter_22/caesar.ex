defprotocol Caesar do
  @moduledoc """
  Protocol for exercise 1, Chapter 22, Programming Elixir 1.2
  """

  def encrypt(string, shift)
  def rot13(string)
end

defimpl Caesar, for: [List, BitString] do
  @num_letters ?z - ?a + 1
  @offset ?a
  defp _encrypt(char, shift) do
    rem(char + shift - @offset, @num_letters) + @offset
  end

  def encrypt([], _shift) do
    []
  end
  def encrypt([head | rest], shift) do
    [_encrypt(head, shift) | encrypt(rest, shift)]
  end
  def encrypt(<<>>, _shift) do
    <<>>
  end
  def encrypt(<<head :: utf8, rest :: binary>>, shift) do
    <<_encrypt(head, shift), encrypt(rest, shift) :: binary>>
  end

  def rot13(string), do: encrypt(string, 13)
end

defmodule RotWordCheck do
  def word_check(string, path) do
    File.stream!(path, [], :line)
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == String.length(string) && &1 == Caesar.rot13(string)))
  end
end