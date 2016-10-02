defmodule ControlFlow do
  @moduledoc false

  def ok!({:ok, data}), do: data
  def ok!(param), do: raise "#{inspect param}"
  def fizzbuzz(n) do
    case {rem(n, 3), rem(n, 5)} do
      {0, 0} -> "FizzBuzz"
      {0, _} -> "Fizz"
      {_, 0} -> "Buzz"
      _ -> n
    end
  end
end