defmodule Axobotl.Consumer do

  use Nostrum.Consumer
  alias Nostrum.Api

  def start_link do
    Axobotl.welcome()
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    cond do
      msg.content == "!ping" -> Api.create_message(msg.channel_id, "pong!")
      String.starts_with?(msg.content, "!echo ")    ->  Echo.handle(msg)
      String.starts_with?(msg.content, "!axolotl ") ->  Axolotl.handle(msg)
      String.starts_with?(msg.content, "!catfact")  ->  Catfact.handle(msg)
      String.starts_with?(msg.content, "!catchcat") ->  Catservice.handle(msg)
      String.starts_with?(msg.content, "!validate") ->  Validation.handle(msg)
      String.starts_with?(msg.content, "!src")      ->  Search.handle(msg)
      String.starts_with?(msg.content, "!stalk")    ->  Stalk.handle(msg)

      verify_command(msg.content, "!axolotl")       -> Axolotl.handle(msg)
      verify_command(msg.content, "!fancyfy")       -> Fancyfy.handle(msg)
      verify_command(msg.content, "!define")         -> Define.handle(msg)
      verify_command(msg.content, "!hanzi")         -> Hanzi.handle(msg)
      verify_command(msg.content, "!hello")         -> Hello.handle(msg)
      verify_command(msg.content, "!joke")          -> Joke.handle(msg)
      verify_command(msg.content, "!zoo")           -> Zoo.handle(msg)
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
