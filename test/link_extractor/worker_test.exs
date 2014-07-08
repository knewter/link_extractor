defmodule LinkExtractor.WorkerTest do
  use ExUnit.Case
  alias LinkExtractor.Link

  @message """
  Ctrl-p: https://github.com/kien/ctrlp.vim
  """

  @expected_link %Link{
    url: "https://github.com/kien/ctrlp.vim"
  }

  test "extracts links from messages" do
    assert LinkExtractor.Worker.extract_links(@message) == [@expected_link]
  end
end
