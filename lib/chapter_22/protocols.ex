defprotocol EnumExt do
  def each(enumerable, fun)
  def filter(enumerable, fun)
  def map(enumerable, fun)
end

defmodule EnumExt.Any do
  require Enum

  def each(enumerable, fun) do
    Enum.reduce enumerable, :ok, fn(elem, acc) ->
      fun.(elem)
      acc
    end
  end
end

defimpl EnumExt, for: List do
  defdelegate each(enumerable, fun), to: EnumExt.Any

  def filter(enumerable, fun) do
    Enum.reduce enumerable, [], fn(elem, acc) ->
      if fun.(elem) do
        [elem | acc]
      else
        acc
      end
    end
  end

  def map(enumerable, fun) do
    Enum.reduce enumerable, [], fn(elem, acc) ->
      [fun.(elem) | acc]
    end
  end
end

defimpl EnumExt, for: Map do
  require Map

  defdelegate each(enumerable, fun), to: EnumExt.Any

  def filter(enumerable, fun) do
    Enum.reduce enumerable, %{}, fn(kv, acc) ->
      if fun.(kv) do
        Map.put(acc, elem(kv, 0), elem(kv, 1))
      else
        acc
      end
    end
  end

  def map(enumerable, fun) do
    Enum.reduce enumerable, %{}, fn(kv, acc) ->
      Map.put(acc, elem(kv, 0), fun.(kv))
    end
  end
end