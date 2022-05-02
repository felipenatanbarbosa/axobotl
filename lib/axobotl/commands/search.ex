defmodule Search do
  alias Nostrum.Api

  def handle(msg) do
    [_head | args]    = String.split(msg.content, " ", parts: 2)

    case args do
      [] ->
        Api.create_message(msg.channel_id, "Uso: *!src <query>*")

      _  ->
        handle_request(msg.channel_id, args)
    end
  end

  def handle_request(channel_id, query) do
    request = "https://imsea.herokuapp.com/api/1?q=#{query}"
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!
    |> Map.get("results")

    case request do
      [] ->
        Api.create_message(channel_id, "A pesquisa não encontrou nenhuma imagem.")

      _  ->
        Api.create_message(channel_id, Enum.fetch!(request, Enum.random(0..length(request) - 1)))
    end
  end
end