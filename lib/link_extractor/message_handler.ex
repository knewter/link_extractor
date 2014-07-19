defmodule LinkExtractor.MessageHandler do
  use GenServer
  alias LinkExtractor.Link
  @url_regex ~r(https?://[^ $\n]*)

  def start_link(_options) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def handle_message(server, message) do
    GenServer.call(server, {:handle_message, message})
  end

  ## Server callbacks
  def init(_options) do
    {:ok, []}
  end

  def handle_call({:handle_message, message}, _from, state) do
    extract_links(message)
    |> Enum.map(fn link ->
      spawn(LinkExtractor, :handle_link, [link])
    end)
    {:reply, :ok, state}
  end

  def extract_links(message) do
    Regex.scan(@url_regex, message)
    |> Enum.map(&hd/1)
    |> Enum.map(&(%Link{url: &1}))
  end
end
