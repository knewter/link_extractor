defmodule LinkExtractor.Collector do
  use GenServer

  def start_link(existing_links \\ []) do
    GenServer.start_link(__MODULE__, existing_links, [])
  end

  def add_link(link) do
    GenServer.cast(:collector, {:add_link, link})
  end

  def get_links do
    GenServer.call(:collector, :get_links)
  end

  ## Server callbacks
  def init(state) do
    {:ok, state}
  end

  def handle_cast({:add_link, link}, state) do
    {:noreply, [link|state]}
  end

  def handle_call(:get_links, _from, state) do
    IO.puts "get_links"
    {:reply, state, state}
  end
end
