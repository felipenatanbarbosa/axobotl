defmodule Axolotl do
  
  alias Nostrum.Api

  def handle(msg) do
    [_head | tail] = String.split(msg.content, " ", parts: 2)
    [args | _tail] = tail
    resp = HTTPoison.get!("https://axoltlapi.herokuapp.com/")
    {:ok, map} = Poison.decode(resp.body)
    IO.puts(args)
    cond do
      args == "fact" -> Api.create_message(msg.channel_id, map["facts"])
      args == "picture" -> Api.create_message(msg.channel_id, map["url"])
      true -> Api.create_message(msg.channel_id, "Escolha inválida")
    end
  end

end
