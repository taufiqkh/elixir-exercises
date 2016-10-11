defmodule Tracer do
  def dump_args(args) do
    args |> Enum.map(&inspect/1) |> Enum.join(",")
  end

  def dump_defn(name, args) do
    "#{name}(#{dump_args(args)})"
  end

  defmacro def(definition, do: content) do
    {name, args} = case definition do
      {:when, _, [{n, _, a}, _cond]} -> {n, a}
      {n, _, a} -> {n, a}
    end
    IO.puts("Definition: #{inspect definition}")
    IO.puts("Content:    #{inspect content}")
    quote do
      Kernel.def unquote(definition) do
        IO.puts("==> call:   #{Tracer.dump_defn(unquote(name), unquote(args))}")
        result = unquote(content)
        IO.puts("<== resp:   #{inspect result}")
        result
      end
    end
  end

  # Alternative, experimenting with using a macro from a macro
  defmacro altdef({:when, _, [{name, _, args}, _cond]} = definition, do: content) do
    quote do: Tracer.def(unquote(name), unquote(args), unquote(definition), unquote(content))
  end
  defmacro altdef({name, _, args} = definition, do: content) do
    quote do: Tracer.def(unquote(name), unquote(args), unquote(definition), unquote(content))
  end
  defmacro altdef(name, args, definition, content) do
    quote do
      Kernel.def unquote(definition) do
        IO.puts("==> call:   #{Tracer.dump_defn(unquote(name), unquote(args))}")
        result = unquote(content)
        IO.puts("<== resp:   #{inspect result}")
        result
      end
    end
  end
end
