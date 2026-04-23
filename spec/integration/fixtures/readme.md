# my-library

A **small** library for doing *things*.

## Installation

Add to `shard.yml`:

```yaml
dependencies:
  my-library:
    github: acme/my-library
    version: "~> 1.0"
```

Then run:

```
shards install
```

## Usage

Call the main entry point:

```crystal
require "my-library"

MyLibrary.do_thing("hello")
```

## Features

- Zero dependencies
- Pure Crystal
- MIT licensed

## Links

- [Documentation](https://example.com/docs)
- [Issue tracker](https://example.com/issues)

> Note: this is a README-shaped fixture used by integration tests.

---

Released under the MIT license.
