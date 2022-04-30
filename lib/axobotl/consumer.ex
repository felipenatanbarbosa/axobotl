defmodule Axobotl.Consumer do

  use Nostrum.Consumer
  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    cond do
      # Comandos de teste
      msg.content == "!ping" -> Api.create_message(msg.channel_id, "pong!")
      String.starts_with?(msg.content, "!echo ") -> Echo.handle(msg)
      # Comandos com parâmetros
      String.starts_with?(msg.content, "!axolotl ") -> Axolotl.handle(msg)
      String.starts_with?(msg.content, "!define ") -> Define.handle(msg)
      String.starts_with?(msg.content, "!hanzi ") -> Hanzi.handle(msg)
      String.starts_with?(msg.content, "!fancyfy ") -> Fancyfy.handle(msg)
      # Comandos sem parâmetros
      String.starts_with?(msg.content, "!hello") -> Hello.handle(msg)
      String.starts_with?(msg.content, "!joke") -> Joke.handle(msg)
      true -> :noop
    end
  end

  def handle_event(_event) do
    :noop
  end

end
