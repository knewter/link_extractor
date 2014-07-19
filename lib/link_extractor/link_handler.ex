defmodule LinkExtractor.LinkHandler do
  use GenServer
  alias LinkExtractor.Link

  def start_link(_options) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def handle_link(server, link) do
    GenServer.call(server, {:handle_link, link})
  end

  ## Server callbacks
  def init(_options) do
    {:ok, []}
  end

  def handle_call({:handle_link, link}, _from, state) do
    link_with_title = add_title(link)
    Agent.update(:collector, &([link_with_title|&1]))
    {:reply, :ok, state}
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
