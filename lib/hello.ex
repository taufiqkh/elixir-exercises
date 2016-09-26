defmodule Hello do
  @moduledoc false
  
  use Application

  def span(n, n), do: [n]
  def span(from, to), do: [from | span(from + 1, to)]

  def filter([], _cond), do: []
  def filter([head | tail], condition) do
    if (condition.(head)) do
      [head | filter(tail, condition)]
    else
      filter(tail, condition)
    end
  end

  def flatten([]), do: []
  def flatten([[] | rest]), do: flatten(rest)
  def flatten([[head | tail] | rest]), do: flatten([head | [tail | rest]])
  def flatten([head | tail]), do: [head | flatten(tail)]

  def is_prime(2), do: true
  def is_prime(n) do
    list = for p <- span(2, n - 1), rem(n, p) == 0, do: p
    list == []
  end
  def primes(n) do
    for p <- 2..n, is_prime(p), do: p
  end

  def with_total(order, tax_rates) do
    ship_to = Keyword.fetch!(order, :ship_to)
    if (Keyword.has_key? tax_rates, ship_to) do
      Keyword.put(order, :total_amount, Keyword.fetch!(tax_rates, ship_to))
    else
      order
    end
  end
  def add_total(tax_rates, orders) do
    for order <- orders, do: with_total(order, tax_rates)
  end

end