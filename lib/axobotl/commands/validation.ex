defmodule Validation do
  alias Nostrum.Api

  def handle(msg) do
    [_head | args] = String.split(msg.content, " ", parts: 2)

    case args do
      [] ->
        Api.create_message(msg.channel_id, "Uso: *!validate <Número de celular>*")

      _  ->
        handle_request(msg.channel_id, args)
    end
  end
  
  def handle_request(channel_id, number) do
    api_key = Application.get_env(:Validation, :api_key)
    request = "https://phonevalidation.abstractapi.com/v1/?api_key=#{api_key}&phone=#{number}"
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!
  
    case request["valid"] do
      true  ->
        Api.create_message(channel_id, "```
        Número válido.
        Número formatado: #{request["format"]["local"]}
        Localização: #{request["location"]}
        Operadora: #{request["carrier"]}```")

      false ->
        Api.create_message(channel_id, "telefone inválido.")
    end
  end
end