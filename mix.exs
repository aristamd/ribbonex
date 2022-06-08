defmodule Ribbonex.MixProject do
  use Mix.Project

  def project do
    [
      app: :ribbonex,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.11.0"},
      {:jason, "~> 1.3"},
      {:ecto, "~> 3.7"},
      {:nimble_options, "~> 0.4.0"},
      {:ex_doc, "~> 0.28.3", only: :dev, runtime: false},
      {:dotenv, "~> 3.1", only: [:dev, :test]},
      {:bypass, "~> 2.1", only: :test}
    ]
  end

  defp aliases do
    [
      "deps.install": [
        "deps.get",
        "deps.compile",
        "deps.clean --unused"
      ],
      "deps.i": "deps.install"
    ]
  end
end
