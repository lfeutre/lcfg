# lcfg

[![Build Status][gh-actions-badge]][gh-actions]
[![LFE Versions][lfe-badge]][lfe]
[![Erlang Versions][erlang-badge]][versions]
[![Tags][github-tags-badge]][github-tags]
[![Downloads][hex-downloads]][hex-package]

*An LFE library for reading, writing, and merging Erlang, LFE, and TOML configuration data*

[![Project Logo][logo]][logo-large]


## Contents

* [Introduction](#introduction-)
* [Usage](#usage-)
* [License](#license-)

## Introduction [&#x219F;](#contents)

The origins of lcfg lay in a prehistoric desire to configure LFE projects in the S-expressions of LFE syntax, as opposed to the config syntax of Erlang. That initial impetus sputtered and the finally died a mere 3-4 years after lcfg's inception.

Since then, many LFE projects have foundered on, written, rewritten, or re-invented various means of pulling configuration data from both Erlang and non-Erlang sources. Addressing some of the issues inherent in those efforts is the new use case to which lcfg now applies itself as a potential solution.

This project is currently in the process of being rewritten from scratch; to track the progress, view this ticket:
* https://github.com/lfeutre/lcfg/issues/25

## Usage [&#x219F;](#contents)

TBD

## Development [&#x219F;](#contents)

If working on this library and you want to test some Erlang functionality interactively:

``` sh
./bin/lcfg-erl -config ./priv/examples/erlang.config
```

``` erlang
1> lcfg:appenv(lcfg).
#{example1 => #{key1 => value1,key2 => value2},
  example2 => #{key3 => value3},
  example3 => #{example4 => #{key5 => value5}}}
```

Similarly, for LFE functionality:

``` sh
./bin/lcfg-lfe -config ./priv/examples/erlang.config
```

``` lisp
lfe> (lcfg:appenv 'lcfg)
#M(example1 #M(key1 value1 key2 value2) example2 #M(key3 value3)
   example3 #M(example4 #M(key5 value5)))
```

## License [&#x219F;](#contents)

Apache License, Version 2.0

Copyright © 2013-2025, Duncan McGreggor <oubiwann@gmail.com>

[//]: ---Named-Links---

[logo]: priv/images/Illustration_Ficus_carica0-small.jpg
[logo-large]: priv/images/Illustration_Ficus_carica0.jpg
[screenshot]: priv/images/screenshot.png
[org]: https://github.com/lfeutre
[github]: https://github.com/lfeutre/lcfg
[gh-actions-badge]: https://github.com/lfeutre/lcfg/workflows/ci%2Fcd/badge.svg
[gh-actions]: https://github.com/lfeutre/lcfg/actions
[lfe]: https://github.com/lfe/lfe
[lfe-badge]: https://img.shields.io/badge/lfe-2.2+-blue.svg
[erlang-badge]: https://img.shields.io/badge/erlang-23%20to%2027-blue.svg
[versions]: https://github.com/lfeutre/dirs/blob/main/rebar.config
[github-tags]: https://github.com/lfeutre/lcfg/tags
[github-tags-badge]: https://img.shields.io/github/tag/lfeutre/lcfg.svg
[github-downloads]: https://img.shields.io/github/downloads/lfeutre/lcfg/total.svg
[hex-badge]: https://img.shields.io/hexpm/v/lcfg.svg?maxAge=2592000
[hex-package]: https://hex.pm/packages/lcfg
[hex-downloads]: https://img.shields.io/hexpm/dt/lcfg.svg
