defmodule CountMinSketch.MixProject do
  use Mix.Project

  @source_url "https://github.com/mrnovalles/count_min_sketch"

  def project do
    [
      app: :count_min_sketch,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Mariano Vallés"],
      description: "Minimal Count-Min Sketch implementation in Elixir",
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
