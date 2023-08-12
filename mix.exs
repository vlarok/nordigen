defmodule Nordigen.MixProject do
  use Mix.Project

  def project do
    [
      app: :nordigen,
      version: "0.1.2",
      elixir: "~> 1.13",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/vlarok/nordigen"
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:elixir_uuid, "~> 1.2"},
      {:poison, "~> 5.0"},
      {:ex_doc, "~> 0.13", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Unofficial Nordigen Client Library"
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Vladimir Rokovanov"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/vlarok/nordigen"}
    ]
  end
end
