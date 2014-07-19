defmodule LinkExtractorTest do
  use ExUnit.Case
  alias LinkExtractor.Link

  @message """
  Augie,

  bad link - http://nope

  Ctrl-p: http://github.com/kien/ctrlp.vim

  That is probably my absolute favorite vim plugin
  """

  @expected_link %Link{
    url: "http://github.com/kien/ctrlp.vim",
    title: "kien/ctrlp.vim · GitHub"
  }

  test "when text is injected into the system, those links are stored" do
    LinkExtractor.inject @message
    :timer.sleep 3000
    assert LinkExtractor.get_links == [@expected_link]
  end

end
