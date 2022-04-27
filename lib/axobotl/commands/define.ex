defmodule Define do

  alias Nostrum.Api

  def handle(msg) do
    [_head | tail] = String.split(msg.content, " ", parts: 2)
    [arg | _tail] = tail
    resp = HTTPoison.get!("https://api.dictionaryapi.dev/api/v2/entries/en/" <> arg)
    {:ok, map} = Poison.decode(resp.body)
    [map] = map
    meanings = map["meanings"]
    Enum.each(meanings, fn x -> Api.create_message(msg.channel_id, format_definitions(x["definitions"], x["partOfSpeech"] <> ":")) end)
  end

  defp format_definitions([], str), do: str
  defp format_definitions(arr, str) do
    [head | tail] = arr
    new_str = str <> "\n   " <> head["definition"]
    format_definitions(tail, new_str)
  end

end
