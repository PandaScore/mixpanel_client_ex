defmodule MixpanelClientEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :mixpanel_client_ex,
      name: "mixpanel_client_ex",
      description: "Basic Elixir implementation of Mixpanel ingestion API (https://developer.mixpanel.com/reference/ingestion-api)",
      package: %{
        licenses: ["MIT"],
        links: %{
          github: "https://github.com/PandaScore/mixpanel_client_ex"
        }
      },
      source_url: "https://github.com/PandaScore/mixpanel_client_ex",
      homepage_url: "https://github.com/PandaScore/mixpanel_client_ex",
      version: "1.1.2",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:jason, ">= 1.0.0"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:mox, "~>1.0", only: [:test]}
    ]
  end
end
