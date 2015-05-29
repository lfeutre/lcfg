# lcfg
*The LFE library for managing and using lfe.config files*

<a href="resources/images/Illustration_Ficus_carica0.jpg"><img src="resources/images/Illustration_Ficus_carica0-small.jpg"/></a>


## Table of Contents

* [Introduction](#introduction-)
* [Dependencies](#dependencies-)
* [Usage](#usage-)
  * [project](#project-)
    * [deps](#deps-)
    * [meta](#meta-)
  * [logging](#logging-)
  * [application](#application-)
  * [relx](#relx-)
  * [Functions in config files](#functions-in-config-files-)
  * [Referencing other config items](#referencing-other-config-items-)


## Introduction [&#x219F;](#table-of-contents)


``lcfg`` is the library behind the ``lfe.config`` file.

lcfg's philosophy is to consolidate the configuration needs for a single project and
avoid the proliferation of configuration files in the codebase.

This library is intented to be used by projects during their creation,
dependency download, compile, etc., phases. As such, this library should
be "bootstrapped" ([lfetool](https://github.com/lfe/lfetool) uses it and
installs it into ``~/.lfe/deps``).


## Dependencies [&#x219F;](#table-of-contents)

This library requires only that [LFE](https://github.com/rvirding/lfe) be
installed.


## Usage [&#x219F;](#table-of-contents)

Usage is the same as any other Erlang or LFE library :-)


### ``project`` [&#x219F;](#table-of-contents)


#### ``deps`` [&#x219F;](#table-of-contents)

Given an ``lfe.config`` (such as ``lfe.config.sample`` found in this repo)
with project dependencies defined:

```cl
#(project
  (#(deps
    (#("rvirding/lfe" "develop")
     #("lfex/lutil" "master")
     "dysinger/lfesl"
     "lfex/ltest"))))
```

Executing the following command will download the dependencies listed,
circumventing ``rebar`` completely:

```cl
> (lcfg:clone-deps)
lfetool ~>> git: destination path 'deps/lfe' already exists ...
lfetool ~>> git: destination path 'deps/lutil' already exists ...
lfetool ~>> Cloning into deps/lfesl...
lfetool ~>> git: destination path 'deps/ltest' already exists ...
ok
>
```

Even though the configuration file is in LFE syntax, this is also usable from
Erlang:

```erlang
1> lcfg:'clone-deps'().
lfetool ~>> git: destination path 'deps/lfe' already exists ...
lfetool ~>> git: destination path 'deps/lutil' already exists ...
lfetool ~>> Cloning into deps/lfesl...
lfetool ~>> git: destination path 'deps/ltest' already exists ...
ok
2>
```

#### ``meta`` [&#x219F;](#table-of-contents)

lcfg also supports metadata, not unlike what Elixir's ``expm`` project originally supported.
Here is an example:
```cl
#(project
  (#(meta
     (#(name lcfg)
      #(description "A library for managing and using lfe.config files.")
      #(version "0.0.2")
      #(keywords ("LFE" "Lisp" "Library" "Configuration" "Utility"))
      #(maintainers
        ((#(name "Duncan McGreggor") #(email "oubiwann@gmail.com"))))
      #(repos
        (#(github "lfex/lcfg")))))))
```

If you also declare ``deps`` just know that ``meta`` and ``deps`` are siblings (keys in the same property list).

### ``logging`` [&#x219F;](#table-of-contents)

lcfg supports logging configuration. Currently the only supported logging
backend is [lager](https://github.com/basho/lager). The top-level ``logging``
configuration option has three sub-options:

 * ``log-level``
 * ``backend``
 * ``options``

The last is what gets passed to the backend. As such, it needs to hold all
the information you want your backend to be configured with. See the
[sample lfe.config file](lfe.config.sample) for a working example of a
lager configuration.

### ``application`` [&#x219F;](#table-of-contents)

With the introduction of ``application`` support, lcfg aims to obselete the need for
LFE projects to maintain a ``src/XXX.app.src`` file, thus eliminating redundant
information. The lfcg ``Makefile`` includes a target called ``compile-app-src``
which generates a ``.app`` file in the ``./ebin`` directory whose contents are built
from metadata in ``lfe.config``.

### ``relx`` [&#x219F;](#table-of-contents)

If you define a ``relx`` section of your config file
(see [lfe.config.relx.sample](lfe.config.relx.sample) for example usage),
lcfg can generate a ``relx.config`` file for you to use when building a
release.

### Functions in config files [&#x219F;](#table-of-contents)

lcfg supports functions in config files. In order to work, the top-level tuple
for the config item needs to be ``backquote``'ed. For example, if the following\
was saved to ``./lfe.local``:

```cl
#(project
  (#(deps
    (#("rvirding/lfe" "develop")
     #("lfex/lutil" "master")
     "dysinger/lfesl"
     "lfex/ltest"))))
`#(opt-1 (,(lutil:get-lfe-version)))
```

When ``(lcfg-file:parse-local)`` is called, it would be rendered as:

```cl
> (lcfg-file:parse-local)
(#(project
   (#(deps
      (#("rvirding/lfe" "develop")
       #("lfex/lutil" "master")
       "dysinger/lfesl"
       "lfex/ltest"))))
 #(opt-1 ("0.9.0"))
```

Note that when calling ``(lcfg-file:read-local)``, top-level ``backquote``ed
items will be ignored, e.g.:

```cl
> (lcfg-file:read-local)
(#(project
   (#(deps
      (#("rvirding/lfe" "develop")
       #("lfex/lutil" "master")
       "dysinger/lfesl"
       "lfex/ltest"))))
```

### Referencing other config items [&#x219F;](#table-of-contents)

lcfg supports the ability to extract items that were configured in different
(static, unevaluated) sections. For example, given this configuration:

```cl
#(project (#(deps (#("rvirding/lfe" "develop")
                   #("lfex/lutil" "master")
                   "dysinger/lfesl"
                   "lfex/ltest"))))
#(cfg-data (#(some (#(thing "else")
                    #(or "other")
                    #(can "be")
                    #(configured "here")))))
`#(opt-1 (,(lutil:get-lfe-version)))
`#(opt-2 (#(data-from-config ,(lcfg:get-in 'local '(cfg-data some can)))))
```

One can do this:

```cl
> (lcfg-file:parse-local)
(#(project
   (#(deps
      (#("rvirding/lfe" "develop")
       #("lfex/lutil" "master")
       "dysinger/lfesl"
       "lfex/ltest"))))
 #(cfg-data
   (#(some (#(thing "else") #(or "other") #(can "be") #(configured "here")))))
 #(opt-1 ("0.9.0"))
 #(opt-2 (#(data-from-config "be"))))
```
