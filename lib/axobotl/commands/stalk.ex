defmodule Stalk do
  alias Nostrum.Api

  def handle(msg) do
    [_ | tail] = String.split(msg.content, " ", parts: 2) 


    cond do
      String.starts_with?(Enum.fetch!(tail, 0), "<@") ->
        tail |> Enum.fetch!(0) |> String.split(~r"[^\d]", trim: true) |> handle_request(msg.channel_id)
        
      Enum.any?(tail) ->
        Api.create_message(msg.channel_id, "Entrada inválida.")
    end
  end

  defp handle_request(user, channel_id) do
    request = "https://api.lanyard.rest/v1/users/#{user}"
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!

    cond do
      request["success"] == :true  ->
        handle_stalk(request["data"], channel_id)

      request["success"] == :false ->
        Api.create_message(channel_id, "Usuário não registrado!")
    end
  end

  defp handle_stalk(activity, channel_id) do
    case activity["activities"] do
      [] ->
        Api.create_message(channel_id, "```
          Usuário: #{activity["discord_user"]["username"]}
          Status: #{activity["discord_status"]}
          Atividade: nenhum jogo em andamento
        ```")
      _  ->
        Api.create_message(channel_id, "```
          Usuário: #{activity["discord_user"]["username"]}
          Status: #{activity["discord_status"]}
          Atividade: Em jogo #{Enum.fetch!(activity["activities"], 0)["name"]}
        ```")
    end
  end
end