defmodule ExUnitSummary.ConfigStorage do
  @moduledoc """
  Storage for ExUnitSummary Config

  (Global State)
  """
  use GenServer

  alias ExUnitSummary.Config

  def start_link(%Config{} = config) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  @impl GenServer

  def init(%Config{} = config) do
    {:ok, config}
  end

  @spec get_config() :: any()
  def get_config() do
    GenServer.call(__MODULE__, :get_config)
  end

  @impl GenServer
  def handle_call(:get_config, _from, %Config{} = config) do
    {:reply, config, config}
  end
end
