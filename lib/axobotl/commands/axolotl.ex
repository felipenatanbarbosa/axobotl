defmodule Axolotl do

  alias Nostrum.Api

  def handle(msg) do
    [_head | args] = String.split(msg.content, " ", parts: 2)

    case args do
      ["picture"] ->
        handle_request(msg.channel_id, args)

      ["fact"] ->
        handle_request(msg.channel_id, args)

      _ ->
        Api.create_message(msg.channel_id, "Os argumentos válidos são apenas \"picture\" e \"fact\"*")
    end
  end

  def handle_request(channel_id, args) do
    map = "https://axoltlapi.herokuapp.com/"
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!

    case args do
      ["fact"] -> Api.create_message(channel_id, map["facts"])
      ["picture"] -> Api.create_message(channel_id, map["url"])
    end
  end

end
