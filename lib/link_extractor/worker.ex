defmodule LinkExtractor.Worker do
  use GenServer
  alias LinkExtractor.Link
  @url_regex ~r(https?://[^ $\n]*)

  def start_link(_options) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def handle_message(server, message) do
    GenServer.cast(server, {:handle_message, message})
  end

  ## Server callbacks
  def init(_options) do
    {:ok, []}
  end

  def handle_cast({:handle_message, message}, state) do
    extract_links(message)
    |> Enum.map(fn link ->
      Agent.update(:collector, &([link|&1]))
    end)
    {:noreply, state}
  end

  def extract_links(message) do
    Regex.scan(@url_regex, message)
    |> Enum.map(&hd/1)
    |> Enum.map(&(%Link{url: &1}))
    |> Enum.map(&add_title/1)
  end

  defp add_title(link=%Link{url: url}) do
    title_pattern = ~r"<title>([^<]*)</title>"
    body = get_body(url)
    title = Regex.run(title_pattern, body) |> Enum.at(1)
    %Link{link | title: title}
  end

  def get_body(url) do
    response = HTTPoison.get(url)
    %HTTPoison.Response{body: body} = follow_redirects(response)
    body
  end

  defp follow_redirects(response=%HTTPoison.Response{status_code: 200}) do
    response
  end
  defp follow_redirects(response=%HTTPoison.Response{status_code: 301, headers: %{"Location" => location}}) do
    response = HTTPoison.get(location)
    follow_redirects(response)
  end
end
