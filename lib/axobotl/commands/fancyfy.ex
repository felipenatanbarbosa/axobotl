defmodule Fancyfy do

  alias Nostrum.Api

  def handle(msg) do
    [_head | arg] = String.split(msg.content, " ", parts: 2)
    [word | _tail] = arg
    resp = HTTPoison.get!("https://api.dictionaryapi.dev/api/v2/entries/en/" <> word)
    {:ok, map} = Poison.decode(resp.body)
    [map] = map
    meanings = map["meanings"]
    synonyms = get_synonyms(meanings, [])
    IO.inspect(synonyms)
    if Enum.empty?(synonyms) do
      Api.create_message(msg.channel_id, "Nunhum sinônimo foi encontrado para \"#{word}\"")
    else
      Api.create_message(msg.channel_id, Enum.random(synonyms))
    end
  end

  # defp get_from_type(arr, type, result \\ []) do
  #   [head | tail] = arr
  #   if head["partOfSpeech"] == type do
  #     get_from_type(tail, type, result ++ get_synonyms(head["definitions"], []))
  #   else
  #     get_from_type(tail, type, result)
  #   end
  # end

  defp get_synonyms([], result), do: result
  defp get_synonyms(arr, result) do
    [head | tail] = arr
    get_synonyms(tail, result ++ head["synonyms"])
  end



  # Em vez de retornar tudo, fazer retornar uma opção aleatória



end
