defmodule LinkExtractor do
  use Application

  def inject(message, return_pid) do
    :poolboy.transaction(:link_extractor_pool, fn(worker) ->
      LinkExtractor.Worker.handle_message(worker, message, return_pid)
    end)
  end

  def get_links do
    Agent.get(:collector, &(&1))
  end

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok, pid} = Agent.start_link(fn -> [] end, name: :collector)

    pool_options = [
      name: {:local, :link_extractor_pool},
      worker_module: LinkExtractor.Worker,
      size: 5,
      max_overflow: 10
    ]

    children = [
      # Define workers and child supervisors to be supervised
      :poolboy.child_spec(:link_extractor_pool, pool_options, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LinkExtractor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule LinkExtractor.Link do
  defstruct url: ""
end
