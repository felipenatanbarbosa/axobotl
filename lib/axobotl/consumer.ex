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
      verify_command(msg.content, "!axolotl") -> Axolotl.handle(msg)
      verify_command(msg.content, "!define") -> Define.handle(msg)
      verify_command(msg.content, "!hanzi") -> Hanzi.handle(msg)
      verify_command(msg.content, "!fancyfy") -> Fancyfy.handle(msg)
      # Comandos sem parâmetros
      verify_command(msg.content, "!hello") -> Hello.handle(msg)
      verify_command(msg.content, "!joke") -> Joke.handle(msg)
      verify_command(msg.content, "!zoo") -> Zoo.handle(msg)
      true -> :noop
    end
  end
  def handle_event(_event), do: :noop

  defp verify_command(msg, str) do
    command = msg
    |> String.split(" ")
    |> List.first

    command == str
  end

end
