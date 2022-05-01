defmodule Search do
  alias Nostrum.Api

  def handle(msg) do
    [_head | args]    = String.split(msg.content, " ", parts: 2)
    [_head | ammount] = args

    case args do
      [] ->
        Api.create_message(msg.channel_id, "Uso: *!src <query | ammount>*")

      _  ->
        handle_request(msg.channel_id, args, ammount)
    end
  end

  def handle_request(channel_id, query, ammount \\ 1) do
    request = "https://imsea.herokuapp.com/api/1?q=#{query}"
    |> HTTPoison.get
    |> Map.get(:body)

    case request do
      [] ->
        Api.create_message(channel_id, "A pesquisa não encontrou nenhuma imagem.")

      _  ->
        handle_query(channel_id, ammount,request["results"])
    end
  end

  def handle_query(channel_id, ammount, images) do
    images |> Enum.slice(1..ammount)

    for n <- images, do: Api.create_message(channel_id, n)

  end

end