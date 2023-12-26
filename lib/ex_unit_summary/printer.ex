defmodule ExUnitSummary.Printer do
  @moduledoc """
  This module prints results to console
  """
  alias ExUnitSummary.CaseResult
  alias ExUnitSummary.Config
  alias ExUnitSummary.ConfigStorage

  @spec call(maybe_improper_list()) :: :ok
  def call(results) when is_list(results) do
    %Config{print_delay: delay} = config = ConfigStorage.get_config()

    # Delay is used for ensure, that ExUnitSummary print own report after ExUnit.CLIFormatter
    if delay, do: :timer.sleep(delay)

    print(config, results)
  end

  def print(%Config{filter_results: filter_results} = _config, results) do
    failed_list =
      results
      |> Enum.filter(&filter_function(&1, filter_results))
      |> Enum.sort_by(&{&1.case_result, &1.file, &1.line})
      |> Enum.map(&build_row/1)

    if length(failed_list) > 0 do
      result_string =
        "ExUnitSummary (#{filter_results || :all}): \n\n" <> Enum.join(failed_list, "\n")

      IO.puts(result_string)
    end

    :ok
  end

  defp filter_function(%CaseResult{} = _result, filter) when filter in [nil, :all] do
    true
  end

  defp filter_function(%CaseResult{case_result: result} = _result, filter)
       when filter in [:failed, :success] do
    result == filter
  end

  defp build_row(%CaseResult{case_result: result} = case_result) do
    Enum.join([
      if(result == :success, do: IO.ANSI.green(), else: IO.ANSI.red()),
      "mix test ",
      "#{case_result.file}:#{case_result.line}",
      IO.ANSI.blue(),
      " # ",
      "#{case_result.case_name}",
      IO.ANSI.reset()
    ])
  end
end
