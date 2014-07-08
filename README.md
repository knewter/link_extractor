## LinkExtractor

The goal here is to build a system that you can inject messages into, and which
will, through various fire-and-forget internal messages, cause a collection to
build up of extracted links and their metadata.

### Usage

Fire up the application.  Send it messages by:

```elixir
LinkExtractor.inject(message)
```

Later, read out all the links it has extracted from various messages, via:

```elixir
LinkExtractor.get_links
```
