defmodule Axolotl do

  alias Nostrum.Api

  def handle(msg) do
    [_head | args] = String.split(msg.content, " ", parts: 2)

    case args do
      ["picture"] ->
        handle_picture(msg.channel_id)

      ["fact"] ->
        handle_fact(msg.channel_id)

      [] ->
        Api.create_message(msg.channel_id, "O comando precisa de um argumento")

      _ ->
        Api.create_message(msg.channel_id, "Os argumentos válidos são apenas *\"picture\"* e *\"fact\"*")
    end
  end

  def handle_picture(channel_id) do
    map = "https://axoltlapi.herokuapp.com/"
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!

    Api.create_message(channel_id, map["url"])
  end

  def handle_fact(channel_id) do
    map = "https://axoltlapi.herokuapp.com/"
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!

    Api.create_message(channel_id, map["facts"])
  end

end
