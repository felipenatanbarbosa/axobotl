defmodule Hello do

  alias Nostrum.Api

  def handle(msg) do
    options = ["asshole", "bag", "bucket", "bye", "cup", "diabetes", "dumbledore", "even", "everyone", "everything", "family", "flying", "ftfy", "horse", "immensity", "jinglebells", "looking", "maybe", "me", "morning", "no", "pink", "programmer", "question", "ratarse", "ridiculous", "sake", "shit", "single", "thanks", "that", "this", "too", "tucker", "what", "zayn", "zero"]
    resp = HTTPoison.get!("https://www.foaas.com/" <> Enum.random(options) <> "/Axobotl", [{"Accept", "application/json"}])
    {:ok, map} = Poison.decode(resp.body)
    Api.create_message(msg.channel_id, msg.author.username <> ", " <> map["message"])
  end

end
