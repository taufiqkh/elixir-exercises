defmodule MyUnless do
  # Chapter 20, Macros and Code Evaluation, exercise 1. Programming Elixir 1.2
  defmacro unless(condition, clauses) do
    do_clause = Keyword.get(clauses, :do, nil)
    else_clause = Keyword.get(clauses, :else, nil)
    quote do
      if (unquote(condition)) do
        unquote(else_clause)
      else
        unquote(do_clause)
      end
    end
  end
end