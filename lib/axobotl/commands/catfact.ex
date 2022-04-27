defmodule Catfact do
  alias Nostrum.Api

  def handle(msg \\ "!catfact 4") do
    [_head | tail] = String.split(msg.content, " ", parts: 2)

    case tail do
      [] -> 
        Api.create_message(msg.channel_id, "Uso: *!catfact <Número de fatos>*")

      n when n > 1 -> 
        handle_request(tail, msg.channel_id)
    end
  end

  defp handle_response(reqs, channel_id, base_url \\ 'https://cat-fact.herokuapp.com/facts/') do
    for x <- reqs do
      base_url
      |> HTTPoison.get!
      |> Map.get(:body)
      |> {:ok, res} = Poison.decode

      IO.puts(res["text"])
    end
  end
end