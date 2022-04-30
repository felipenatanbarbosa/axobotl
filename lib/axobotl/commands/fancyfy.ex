defmodule Fancyfy do

  alias Nostrum.Api

  def handle(msg) do
    [_head | args] = String.split(msg.content, " ")

    case length(args) do
      1 ->
        handle_request(msg.channel_id, List.first(args))

      _ ->
        Api.create_message(msg.channel_id, "O comando precisa de *apenas* um argumento")
    end

  end

  def handle_request(channel_id, args) do
    map = "https://api.dictionaryapi.dev/api/v2/entries/en/" <> args
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!
    |> verify_result
    |> List.first

    if map do
      meanings = map["meanings"]
      synonyms = get_synonyms(meanings, [])

      if Enum.empty?(synonyms) do
        Api.create_message(channel_id, "Nunhum sinônimo foi encontrado para \"#{args}\"")
      else
        Api.create_message(channel_id, Enum.random(synonyms))
      end
    else
      Api.create_message(channel_id, "Palavra inválida")
    end

  end

  defp get_synonyms([], result), do: result
  defp get_synonyms(arr, result) do
    [head | tail] = arr
    get_synonyms(tail, result ++ head["synonyms"])
  end

  # Se o resultado não for uma lista, retorna uma lista vazia
  # É necessário porque List.first retorna nil para [], mas dá erro se não for uma lista
  defp verify_result(map) when is_list(map), do: map
  defp verify_result(_), do: []

end
