defmodule Define do

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

  defp handle_request(channel_id, args) do
    map = "https://api.dictionaryapi.dev/api/v2/entries/en/" <> args
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!
    |> verify_result
    |> List.first

    if map do
      meanings = map["meanings"]
      Enum.each(meanings, fn x -> Api.create_message(channel_id, format_definitions(x["definitions"], x["partOfSpeech"] <> ":")) end)
    else
      Api.create_message(channel_id, "Palavra inválida")
    end
  end

  defp format_definitions([], str), do: str
  defp format_definitions(arr, str) do
    [head | tail] = arr
    new_str = str <> "\n   " <> head["definition"]
    format_definitions(tail, new_str)
  end

  # Se o resultado não for uma lista, retorna uma lista vazia
  # É necessário porque List.first retorna nil para [], mas dá erro se não for uma lista
  defp verify_result(map) when is_list(map), do: map
  defp verify_result(_), do: []

end
