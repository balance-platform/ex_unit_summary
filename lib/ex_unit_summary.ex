defmodule ExUnitSummary do
  @moduledoc false
  use Application
  alias ExUnitSummary.Config

  def start(:normal, %Config{} = config) do
    children = [
      {ExUnitSummary.ConfigStorage, config},
      {ExUnitSummary.Formatter, config},
      {ExUnitSummary.Recorder, []}
    ]

    opts = [strategy: :one_for_one, name: ExUnitSummary.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
