defmodule LinkExtractor.Worker do
  use GenServer
  alias LinkExtractor.Link

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def handle_message(server, message, return_pid) do
    GenServer.cast(server, {:handle_message, message, return_pid})
  end

  ## Server callbacks
  def init(:ok) do
    {:ok, []}
  end

  def handle_cast({:handle_message, message, return_pid}, state) do
    extract_links(message)
    |> Enum.map(fn(link) ->
      LinkExtractor.Collector.add_link(link)
    end)
    {:noreply, state}
  end

  ## Other?
  def extract_links(message) do
    Regex.scan(~r/https?:\/\/[^ $\n]*/, message)
    |> Enum.map(&hd/1)
    |> Enum.map(&(%Link{url: &1}))
  end
end
