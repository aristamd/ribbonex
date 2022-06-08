defmodule Ribbonex.Query do
  @doc """
  Encodes the given map or list of tuples.
  """
  def encode(kv, encoder \\ &to_string/1) do
    IO.iodata_to_binary(encode_pair("", kv, encoder))
  end

  # covers structs
  defp encode_pair(field, %{__struct__: struct} = map, encoder) when is_atom(struct) do
    [field, ?= | encode_value(map, encoder)]
  end

  # covers maps
  defp encode_pair(parent_field, %{} = map, encoder) do
    encode_kv(map, parent_field, encoder)
  end

  # covers keyword lists
  defp encode_pair(parent_field, list, encoder) when is_list(list) and is_tuple(hd(list)) do
    encode_kv(Enum.uniq_by(list, &elem(&1, 0)), parent_field, encoder)
  end

  # covers non-keyword lists
  defp encode_pair(parent_field, list, encoder) when is_list(list) do
    encode_pair(parent_field, Enum.join(list, ","), encoder)
  end

  # covers nil
  defp encode_pair(field, nil, _encoder) do
    [field, ?=]
  end

  # encoder fallback
  defp encode_pair(field, value, encoder) do
    [field, ?= | encode_value(value, encoder)]
  end

  defp encode_kv(kv, parent_field, encoder) do
    mapper = fn
      {_, value} when value in [%{}, []] ->
        []

      {field, value} ->
        field =
          if parent_field == "" do
            encode_key(field)
          else
            parent_field <> "[" <> encode_key(field) <> "]"
          end

        [?&, encode_pair(field, value, encoder)]
    end

    kv
    |> Enum.flat_map(mapper)
    |> prune()
  end

  defp encode_key(item) do
    item |> to_string |> URI.encode_www_form()
  end

  defp encode_value(item, encoder) do
    item |> encoder.() |> URI.encode_www_form()
  end

  defp prune([?& | t]), do: t
  defp prune([]), do: []
end
