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
      {:roulette, github: "lyokato/roulette", ref: "1c016b92da15a98ac39520d73e1d7aecdae37ef1"},
      {:httpoison, "~> 1.1"},
      {:secure_random, "~> 0.5.1"},
      {:riverside, "~> 1.1.0"}
    ]
  end
end
