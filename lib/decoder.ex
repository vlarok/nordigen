defmodule Decoder do
  defmacro schema(str_fields, block \\ [do: nil])

  defmacro schema(str_fields, [do: _] = block) do
    quote do
      defstruct Enum.map(unquote(str_fields), &String.to_atom/1)

      def decode(%{} = map) do
        map
        |> Map.take(unquote(str_fields))
        |> Enum.map(fn({k, v}) -> {String.to_existing_atom(k), v} end)
        |> Enum.map(&decode/1)
        |> fn(data) -> struct(__MODULE__, data) end.()
      end

      unquote(block)

      def decode({k, v}), do: {k, v}
    end
  end

  defmacro field(field, args) do
    quote do
      cond do
        is_atom(unquote(args)) ->
          def decode({unquote(field), arg}) when is_list(arg) do
            {unquote(field), Enum.map(arg, fn(data) -> unquote(args).decode(data) end)}
          end

          def decode({unquote(field), arg}) when is_map(arg) do
            {unquote(field), unquote(args).decode(arg)}
          end

        is_function(unquote(args)) ->
          def decode({unquote(field), arg}) when is_list(arg) do
            {unquote(field), Enum.map(arg, fn(data) -> unquote(args).(data) end)}
          end
      end

    end
  end
end
