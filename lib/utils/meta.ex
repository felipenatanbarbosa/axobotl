defmodule Util do
  def typeof(a) do
    cond do
        is_float(a)    -> IO.puts("float")
        is_number(a)   -> IO.puts("number")
        is_atom(a)     -> IO.puts("atom")
        is_boolean(a)  -> IO.puts("boolean")
        is_binary(a)   -> IO.puts("binary")
        is_function(a) -> IO.puts("function")
        is_list(a)     -> IO.puts("list")
        is_tuple(a)    -> IO.puts("tuple")
        true           -> IO.puts("sei lá que diacho é isso")
    end
  end
end