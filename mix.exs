defmodule LinkExtractor.Mixfile do
  use Mix.Project

  def project do
    [app: :link_extractor,
     version: "0.0.1",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:httpoison],
      mod: {LinkExtractor, []},
      registered: [
        :collector,
        :link_extractor_message_handler_pool,
        :link_extractor_link_handler_pool
      ]
    ]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:poolboy, "~> 1.2.1"},
      {:httpoison, "~> 0.3.0"},
      {:hackney, github: "benoitc/hackney"}
    ]
  end
end
