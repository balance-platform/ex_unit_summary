defmodule ExUnitSummary.MixProject do
  use Mix.Project

  @source_url "https://github.com/balance-platform/ex_unit_summary"
  @version "0.2.0"

  @spec project() :: list()

  def project do
    [
      app: :ex_unit_summary,
      version: @version,
      aliases: aliases(),
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      description: description(),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      homepage_url: @source_url,
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  @spec application() :: list()

  def application do
    [
      extra_applications: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  @spec deps() :: list()

  defp deps do
    [
      {:credo, ">= 1.0.0", only: [:dev, :test], runtime: false},
      {:recode, ">= 0.5.0", only: :dev},
      {:dialyxir, ">= 1.3.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.21.0", only: [:dev], runtime: false},
      {:excoveralls, ">= 0.12.2", only: [:test], runtime: false}
    ]
  end

  @spec description() :: String.t()
  defp description do
    """
    The library outputs test results to the console, which helps speed up the red-green test correction cycle

    (inspired by rspec)
    """
  end

  @spec package() :: list()

  defp package do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "ex_unit_summary",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  @spec aliases() :: list()
  defp aliases do
    [
      test: ["format --check-formatted", "test"],
      check_code: ["credo", "format", "dialyzer"]
    ]
  end

  @spec docs() :: list()

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
