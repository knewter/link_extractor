defmodule LinkExtractor.MessageHandlerTest do
  use ExUnit.Case
  alias LinkExtractor.Link

  @message """
  Ctrl-p: https://github.com/kien/ctrlp.vim
  """

  @expected_link %Link{
    url: "https://github.com/kien/ctrlp.vim"
  }

  test "extracts links from messages" do
    assert LinkExtractor.MessageHandler.extract_links(@message) == [@expected_link]
  end
end
