defmodule ExUnitSummary.Formatter do
  @moduledoc false
  use GenServer

  alias ExUnitSummary.CaseResult
  alias ExUnitSummary.Printer
  alias ExUnitSummary.Recorder

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_any) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(ex_unit_config) do
    {:ok, ex_unit_config}
  end

  def handle_cast({:suite_finished, _data}, ex_unit_config) do
    results = get_list_of_case_results()
    write_output(results)
    {:noreply, ex_unit_config}
  end

  def handle_cast(:max_failures_reached, ex_unit_config) do
    {:noreply, ex_unit_config}
  end

  def handle_cast({_event_type, _event_data} = event, ex_unit_config) do
    case_result = CaseResult.from_exunit_event(event)
    Recorder.write(case_result)

    {:noreply, ex_unit_config}
  end

  defp get_list_of_case_results() do
    Recorder.get_results()
  end

  defp write_output(results) do
    Printer.call(results)
  end
end
