# lcfg

<a href="resources/images/Illustration_Ficus_carica0.jpg"><img src="resources/images/Illustration_Ficus_carica0-small.jpg"/></a>


## Table of Contents

* [Introduction](#introduction-)
* [Dependencies](#dependencies-)
* [Usage](#usage-)
  * [project](#project-)
    * [deps](#deps-)
  * [Functions in config files](#functions-in-config-files-)
  * [Referencing other config items](#referencing-other-config-items-)


## Introduction [&#x219F;](#table-of-contents)


``lcfg`` is the library behind the ``lfe.config`` file.

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
#(project (#(deps (#("rvirding/lfe" "develop")
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

### Functions in config files [&#x219F;](#table-of-contents)

lcfg supports functions in config files. In order to work, the top-level tuple
for the config item needs to be ``backquote``'ed. For example, if the following\
was saved to ``./lfe.local``:

```cl
#(project (#(deps (#("rvirding/lfe" "develop")
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
