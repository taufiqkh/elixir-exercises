defmodule Tracer do
  @moduledoc false
#  import Kernel, except: [def: 2]

  def dump_args(args) do
    args |> Enum.map(&inspect/1) |> Enum.join(",")
  end

  def dump_defn(name, args) do
    "#{name}(#{dump_args(args)})"
  end

  defmacro def({:when, _, [{name, _, args}, condition]} = definition, do: content) do
    IO.puts("Defining #{inspect definition}")
    quote do
      Kernel.def unquote(definition) do
        IO.puts("==> call:   #{Tracer.dump_defn(unquote(name), unquote(args))}")
        result = unquote(content)
        IO.puts("<== resp:   #{inspect result}")
        result
      end
    end
  end

  defmacro def({name, _, args} = definition, do: content) do
    IO.puts("Defining #{inspect definition}")
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