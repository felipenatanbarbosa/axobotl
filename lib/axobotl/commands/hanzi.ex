defmodule Hanzi do

  alias Nostrum.Api

  def handle(msg) do
    [_head | tail] = String.split(msg.content, " ", parts: 2)
    [arg | _tail] = tail
    resp = HTTPoison.get!("http://ccdb.hemiola.com/characters/mandarin/" <> arg)
    {:ok, map} = Poison.decode(resp.body)
    Api.create_message(msg.channel_id, format_hanzi(map))
  end

  defp format_hanzi([]), do: ""
  defp format_hanzi(arr) do
    [head | tail] = arr
    head["string"] <> "  " <> format_hanzi(tail)
  end

end
