defmodule Throttle.MixProject do
  use Mix.Project

  def project do
    [
      app: :throttle,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Throttle.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      {:roulette, github: "lyokato/roulette", ref: "93b9621fbecb85c7ccfe0526af91d18b6b497624"},
      {:httpoison, "~> 1.1"},
      {:secure_random, "~> 0.5.1"},
      {:riverside, "~> 1.1.0"}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
