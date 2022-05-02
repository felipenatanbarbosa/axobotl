defmodule Catservice do
  alias Nostrum.Api

  def handle(msg) do
    [_ | args] = String.split(msg.content, " ", parts: 2)

    case args do
      [] ->
        Api.create_message(msg.channel_id, "Uso: *!catchcat <Mensagem>*")

      _  -> 
        handle_request(msg.channel_id, args)
    end
  end

  def handle_request(channel_id, caption) do
    url = "https://cataas.com/cat/gif/says/#{caption}"
    Api.create_message(channel_id, url)
  end
end