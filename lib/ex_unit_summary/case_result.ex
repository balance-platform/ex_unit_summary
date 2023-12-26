defmodule ExUnitSummary.CaseResult do
  @moduledoc """
  Wrapper around ExUnit case result
  """
  defstruct [
    :case_type,
    :describe_block_name,
    :case_name,
    :file,
    :line,
    :module,
    :case_result,
    :case_time,
    :error_info
  ]

  @type t() :: %{
          case_result: :failed | :success,
          file: String.t(),
          module: String.t(),
          line: non_neg_integer(),
          case_type: atom(),
          describe_block_name: nil | String.t(),
          case_time: non_neg_integer(),
          error_info: any()
        }

  @spec from_exunit_event({any(), any()}) :: nil | ExUnitSummary.CaseResult.t()
  def from_exunit_event({:test_finished, %ExUnit.Test{state: nil} = event}) do
    from_exunit_finish_event(event)
  end

  def from_exunit_event({:test_finished, %ExUnit.Test{state: {:failed, _info}} = event}) do
    from_exunit_finish_event(event)
  end

  def from_exunit_event({_another_event, _event}) do
    nil
  end

  defp from_exunit_finish_event(%ExUnit.Test{} = event) do
    %__MODULE__{
      case_type: event.tags.test_type,
      case_name: String.replace_leading(to_string(event.name), "test ", ""),
      module: event.module,
      case_result: case_result(event.state),
      error_info: error_info(event.state),
      case_time: time_to_ms(event.time),
      describe_block_name: event.tags.describe,
      line: event.tags.line,
      file: event.tags.file
    }
  end

  defp time_to_ms(time), do: trunc(time / 1000)
  defp case_result(nil), do: :success
  defp case_result({:failed, _reason}), do: :failed
  defp error_info(nil), do: []
  defp error_info({:failed, reason}), do: reason
end
