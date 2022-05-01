defmodule Hanzi do

  alias Nostrum.Api

  def handle(msg) do
    [_head | args] = String.split(msg.content, " ")

    case length(args) do
      1 ->
        handle_request(msg.channel_id, List.first(args))

      0 ->
        Api.create_message(msg.channel_id, "O comando precisa de um argumento")

      _ ->
        Api.create_message(msg.channel_id, "O comando precisa de *apenas* um argumento")
    end

  end

  def handle_request(channel_id, args) do
    map = "http://ccdb.hemiola.com/characters/mandarin/" <> args
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!

    if map == [] do
      Api.create_message(channel_id, "Caractere não encontrado")
    else
      Api.create_message(channel_id, format_hanzi(map))
    end
  end

  defp format_hanzi([]), do: ""
  defp format_hanzi(arr) do
    [head | tail] = arr
    head["string"] <> "  " <> format_hanzi(tail)
  end

end
