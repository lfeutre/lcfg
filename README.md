# lcfg

[![Build Status][gh-actions-badge]][gh-actions]
[![LFE Versions][lfe-badge]][lfe]
[![Erlang Versions][erlang-badge]][versions]
[![Tags][github-tags-badge]][github-tags]
[![Downloads][hex-downloads]][hex-package]

*An Erlang/LFE library for reading, writing, and merging Erlang, LFE, and TOML configuration data*

[![Project Logo][logo]][logo-large]


## Contents

* [Introduction](#introduction-)
* [Usage](#usage-)
* [Development](#development-)
* [License](#license-)

## Introduction [&#x219F;](#contents)

The origins of lcfg lay in a prehistoric desire to configure LFE projects in the S-expressions of LFE syntax, as opposed to the config syntax of Erlang. That initial impetus sputtered and the finally died a mere 3-4 years after lcfg's inception.

Since then, many LFE projects have foundered on, written, rewritten, or re-invented various means of pulling configuration data from both Erlang and non-Erlang sources. Addressing some of the issues inherent in those efforts is the new use case to which lcfg now applies itself as a potential solution.

So what does this project provide for LFE and Erlang developers?

* The ability to read application configuration data (as a map) from multiple sources -- current working directory, OS-standard configuration directories, via a file passed to the Erlang VM via `-config` from release config files (e.g., `sys.config`), and from a project's `app.src` file (the `env` key).
* The ability to do all of this with a single function.
* The option of reading from all possible sources and recursively merging the config data.
* The option of reading from just one, or just one merged with the project's `env` data.

There are a few more features, but those are the broad strokes.

## Usage [&#x219F;](#contents)

Note that the examples here are taken from an LFE REPL session started with `rebar3 lfe repl`.

Show the default list of files that are searched for and read (if present) for configuration data:

``` lisp
lfe> (lcfg:show-paths 'lcfg)
"./lcfg.config"
"./lcfg.lfe"
"./lcfg.toml"
"/Users/oubiwann/Library/Application Support/lcfg/config/lcfg.config"
"/Users/oubiwann/Library/Application Support/lcfg/config/lcfg.lfe"
"/Users/oubiwann/Library/Application Support/lcfg/config/lcfg.toml"
```

The files at the top of that list have the most precedence, with the configuration data in them overriding key/values of other files, including data pulled from the application's `env`.

To view an application's `env` data:

``` lisp
lfe> (lcfg:start)
lfe> (lcfg:appenv 'lcfg)
#M(example1 #M(key1 value1 key2 value2) example2 #M(key3 value3))
```

To see the default options used for reading configuration data from various sources:

``` lisp
lfe> (lcfg:default-options)
#M(app undefined
   use-first true 
   use-env true 
   use-all false)
```

Both these options and the precedence paths listed above may be overridden in functions, allowing developers to define their own default options and orders of precedence for files and application `env` data.

Note that:
* by default, the first highest-precedence configuration file that is found will be used and merged with the application `env` data.
* by enabling `use-all` and disabling `use-first`, _all_ configuration files found will be parsed, and the subsequent maps merged in order of precedence.
* the application `env` data found in a configuration file (e.g., using the `-config` options) will be merged with -- but override duplicate values in -- the application's `app.src` config data in `env`.

More examples ... load application data using all the defaults:

``` lisp
lfe> (lcfg:load 'myapp)
```

Override default options:

``` lisp
lfe> (set opts   #m(app undefined
                    use-all true
                    use-env true
                    use-first false))
lfe> (lcfg:load 'myapp opts)
```

Override default precedence:

``` lisp
lfe> (set prec (++ (lcfg:default-precedence 'myapp) (list "~/.config/myapp.toml")))
lfe> (lcfg:load 'myapp opts prec)
```

And lastly, some functions that may come in handy when setting up configuration files on your system:

``` lisp
lfe> (lcfg:copy "priv/examples/erlang.config" 'lcfg)
#M(result #(ok 180)
   path "/Users/oubiwann/Library/Application Support/lcfg/config/lcfg.config")
```

and

``` lisp
lfe> (lcfg:move "my-config.toml" 'myapp)
#M(result #(ok 294)
   path "/Users/oubiwann/Library/Application Support/myapp/config/myapp.toml")
```

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
