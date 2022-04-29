defmodule Joke do

  alias Nostrum.Api

  def handle(msg) do
    resp = HTTPoison.get!("https://icanhazdadjoke.com/", [{"Accept", "application/json"}])
    {:ok, map} = Poison.decode(resp.body)
    Api.create_message(msg.channel_id, map["joke"])
  end

  def handle() do
    resp = HTTPoison.get!("https://icanhazdadjoke.com/", [{"Accept", "application/json"}])
    {:ok, map} = Poison.decode(resp.body)
    IO.inspect(map)
  end

end
