  defmodule Axobotl.MixProject do
  use Mix.Project

  def project do
    [
      app: :axobotl,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison],
      mod: {Axobotl.Application, []}
    ]
  end

  defp deps do
    [
      {:nostrum, "~> 0.5.1"},
      {:httpoison, "~> 1.8"},
      {:poison, "~> 5.0"}
    ]
  end
end
