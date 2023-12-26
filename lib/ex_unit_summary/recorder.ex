defmodule ExUnitSummary.Recorder do
  @moduledoc false
  use GenServer

  alias ExUnitSummary.CaseResult

  @spec start_link(any()) :: {:ok, pid()}
  def start_link(_anything) do
    {:ok, _} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @spec init(any()) :: {:ok, []}
  def init(_anything) do
    {:ok, []}
  end

  @spec get_results() :: any()
  def get_results() do
    GenServer.call(__MODULE__, :get_results)
  end

  @spec write(nil | CaseResult.t()) :: :ok
  def write(nil) do
    :ok
  end

  def write(%CaseResult{} = case_result) do
    GenServer.cast(__MODULE__, {:write, case_result})
    :ok
  end

  def handle_cast({:write, %CaseResult{} = result}, results) do
    {:noreply, [result | results]}
  end

  def handle_call(:get_results, _from, results) do
    {:reply, results, results}
  end
end
