defmodule LinkExtractorTest do
  use ExUnit.Case
  alias LinkExtractor.Link

  @message """
  Augie,

  Ctrl-p: https://github.com/kien/ctrlp.vim

  That is probably my absolute favorite vim plugin.

  And there's NerdTree for browsing the file tree. 
  """

  @expected_link %Link{
    url: "https://github.com/kien/ctrlp.vim"
  }

  test "when text is emitted into the system, messages come out containing the links in that text" do
    LinkExtractor.inject @message, self
    :timer.sleep 1000
    assert LinkExtractor.get_links == [@expected_link]
  end
end
