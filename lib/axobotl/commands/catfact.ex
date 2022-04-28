defmodule Catfact do
  alias Nostrum.Api


  def handle(msg) do
    [_head | tail] = String.split(msg.content, " ", parts: 2)

    case tail do
      [] -> 
        handle_request(msg.channel_id)

      _ -> 
        Api.create_message(msg.channel_id, "Uso: *!catfact*")

    end
  end

  defp handle_request(channel_id) do
    {:ok, request} = {:ok, "https://cat-fact.herokuapp.com/facts/"} 
    |> elem(1)
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!
    |> Enum.fetch(0)

    Api.create_message(channel_id, request["text"])
    end
end