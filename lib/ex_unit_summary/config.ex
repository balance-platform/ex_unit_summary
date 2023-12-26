defmodule ExUnitSummary.Config do
  @moduledoc """
  Library Configurations

  * print_delay is used to delay output, becouse there is race condition with default ExUnit Formatter
  * filter_results is used to filter, which results should be printed in console
  """
  defstruct print_delay: nil,
            filter_results: nil

  @type t() :: %{
          print_delay: nil | non_neg_integer(),
          filter_results: :failed | :success | :all | nil
        }
end
