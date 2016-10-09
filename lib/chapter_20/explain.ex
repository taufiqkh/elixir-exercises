defmodule Explain do
  @moduledoc false

  defmacro explain({oper, _metadata, [left, right]} = expression) do
    case oper do
      :+ ->
        "add #{left} and #{right}"
      :- ->
        "subtract #{right} from #{left}"
      :/ ->
        "divide #{left} by #{right}"
      :* ->
        "multiply #{left} by #{right}"
    end
  end
  defmacro explain(item) do
    item
  end
end