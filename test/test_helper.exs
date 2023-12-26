ExUnitSummary.start(:normal, %ExUnitSummary.Config{print_delay: 100})
ExUnit.configure(formatters: [ExUnit.CLIFormatter, ExUnitSummary.Formatter])
ExUnit.start()
