defmodule Echo do

  alias Nostrum.Api

  def handle(msg) do
    [_head | args] = String.split(msg.content)
    resp = Enum.join(args, " ")
    Api.create_message(msg.channel_id, resp)
  end

end
