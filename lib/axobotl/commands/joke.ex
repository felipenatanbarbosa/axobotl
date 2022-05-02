defmodule Joke do

  alias Nostrum.Api

  def handle(msg) do
    map = "https://icanhazdadjoke.com/"
    |> HTTPoison.get!([{"Accept", "application/json"}])
    |> Map.get(:body)
    |> Poison.decode!

    Api.create_message(msg.channel_id, map["joke"])
  end

end
