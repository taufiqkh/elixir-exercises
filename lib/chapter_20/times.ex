defmodule Times do
  @moduledoc false

  defmacro times_n(n) do
    times_n = String.to_atom("times_#{n}")
    quote do
      def unquote(times_n)(x) do
        x * unquote(n)
      end
    end
  end
end