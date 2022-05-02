defmodule Zoo do

  alias Nostrum.Api

  def handle(msg) do
    [_head | args] = String.split(msg.content, " ")

    case length(args) do
      1 ->
        arg = List.first(args)
        if Regex.match?(~r/^[1-9]$/, arg) do
          handle_multiple_request(msg.channel_id, arg)
        else
          Api.create_message(msg.channel_id, "O argumento precisa ser um número maior que 0 e menor que 10")
        end

      0 ->
        handle_request(msg.channel_id)

      _ ->
        Api.create_message(msg.channel_id, "O comando recebe no máximo um argumento")
    end
  end

  defp handle_request(channel_id) do
    animal = "https://zoo-animal-api.herokuapp.com/animals/rand"
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!

    print_animal(channel_id, animal)
  end

  defp handle_multiple_request(channel_id, n) do
    map = "https://zoo-animal-api.herokuapp.com/animals/rand/" <> n
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Poison.decode!

    Enum.each(map, fn animal -> print_animal(channel_id, animal) end)
  end

  defp print_animal(channel_id, obj) do
    Api.create_message(channel_id, "**#{obj["name"]}**" <> " - " <> obj["animal_type"])
    Api.create_message(channel_id, obj["image_link"])
    Api.create_message(channel_id, "Vive em: " <> obj["geo_range"])
    Api.create_message(channel_id, "Habitat: " <> obj["habitat"])
    Api.create_message(channel_id, "Dieta: " <> obj["diet"])
  end

end
