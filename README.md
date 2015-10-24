# lcfg

[![][lcfg-logo]][lcfg-logo-large]

[lcfg-logo]: resources/images/Illustration_Ficus_carica0-small.jpg
[lcfg-logo-large]: resources/images/Illustration_Ficus_carica0.jpg

*The LFE library for managing and using lfe.config files*


## Contents

* [Introduction](#introduction-)
* [Dependencies](#dependencies-)
* [Usage](#usage-)
  * [project](#project-)
    * [deps](#deps-)
    * [meta](#meta-)
  * [logging](#logging-)
  * [app.src](#app.src-)
  * [relx](#relx-)
  * [Functions in config files](#functions-in-config-files-)
  * [Referencing other config items](#referencing-other-config-items-)


## Introduction [&#x219F;](#contents)


``lcfg`` is the library behind the ``lfe.config`` file.

lcfg's philosophy is to consolidate the configuration needs for a single project and
avoid the proliferation of configuration files in the codebase.

This library is intented to be used by projects during their creation,
dependency download, compile, etc., phases. As such, this library should
be "bootstrapped" ([lfetool](https://github.com/lfe/lfetool) uses it and
installs it into ``~/.lfe/deps``).


## Dependencies [&#x219F;](#contents)

As of version 0.2.0, this project assumes that you have
[rebar3](https://github.com/rebar/rebar3) installed somwhere in your ``$PATH``.
It no longer uses the old version of rebar. If you do not wish to use rebar3,
you may use the most recent rebar2-compatible release of lutil: 0.1.1.


## Usage [&#x219F;](#contents)

In the sub-sections below are examples of using lcfg, specifically its
first- and second-level configuration directives.

Though the basic assumption is that one would use this in
conjunction with ``lfetool`` and standard LFE project ``Makefile``s,
lcfg is usable with vanilla Erlang. If you have added lcfg
to your ``rebar.config`` like so:

```erlang
   ...
   {lcfg, ".*", {git, "git://github.com/lfex/lcfg.git", "master"}},
   ...
```

then you can do the following:

```bash
$ rebar get-deps
$ cd deps/lcfg && ln -s ../../deps . && make compile && cd -
$ rebar compile
$ cp deps/lcfg/lfe.config.sample lfe.config
$ erl -pa ./ebin ./deps/*/ebin
```

And then, in the Erlang shell:

```erlang
1> 'lcfg-file':'parse-local'().
[{project,[{meta,[{name,'cool-thing'},
                  {description,"Cool Thing!"},
                  {version,"4.2.0"},
                  {id,"kl-prj-xk-4"},
                  {keywords,["LFE",[unquote,"Library"],[unquote,"API"]]},
                  {maintainers,[[{name,"Alice"},{email,"ali@ce.com"}],
                                [{name,"Bob"},{email,"bo@b.com"}]]},
                  {repos,[{github,"cool/thing"},
                          {myhost,"darcs://myhost.com/cool/thing-dev"}]}]},
           {deps,[{"rvirding/lfe","develop"},
                  {"lfex/lutil","master"},
                  "dysinger/lfesl","lfex/ltest"]}],
          {app,[{'max-t',1000},
                {registered,['my-reged-proc-1','proc-2']},
                {modules,[kt,'kt-app','kt-sup','kt-util']},
                {'included-applications',[]},
                {applications,[lager]},
                {env,[]},
                {mod,'$',['start-mod',['arg-1','arg-2']]},
                {'start-phases',[{phs1,['arg-1','arg-2']},{phs2,[arg]}]}]}},
 {'cfg-data',[{some,[{thing,"else"},
                     {'or',"other"},
                     {can,"be"},
                     {configured,"here"}]}]},
 {'opt-1',["0.9.0"]},
 {'opt-2',[{'data-from-config',undefined}]},
 {logging,[{'log-level',info},
           {backend,lager},
           {options,[{lager_console_backend,debug},
                     {lager_file_backend,[{file,"log/error.log"},
                                          {level,error},
                                          {size,10485760},
                                          {date,"$D0"},
                                          {count,5}]},
                     {lager_file_backend,[{file,"log/console.log"},
                                          {level,info},
                                          {size,10485760},
                                          {date,"$D0"},
                                          {count,5}]}]}]}]
2>
```


### ``project`` [&#x219F;](#contents)


#### ``deps`` [&#x219F;](#contents)

Note: **the ``deps`` directive should only be used with rebar2 projects.

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


#### ``meta`` [&#x219F;](#contents)

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


### ``logging`` [&#x219F;](#contents)

lcfg supports logging configuration. Currently the only supported logging
backend is [lager](https://github.com/basho/lager). The top-level ``logging``
configuration option has three sub-options:

 * ``log-level``
 * ``backend``
 * ``options``

The last is what gets passed to the logging backend (e.g., lager). As such,
it needs to hold all the information with which you want your backend to be
configured. See the [sample lfe.config file](lfe.config.sample) for a
working example of a lager configuration.


### ``app.src`` [&#x219F;](#contents)

With the introduction of ``.app.src`` support, lcfg aims to obselete the need for
LFE projects to maintain a ``src/XXX.app.src`` file, thus eliminating redundant
information. The lfcg ``Makefile`` includes a target called ``compile-app-src``
which generates a ``.app`` file in the ``./ebin`` directory whose contents are built
from metadata in ``lfe.config``.


### ``relx`` [&#x219F;](#contents)

If you define a ``relx`` section of your config file
(see [lfe.config.relx.sample](lfe.config.relx.sample) for example usage),
lcfg can generate a ``relx.config`` file for use when building a release.


### Functions in config files [&#x219F;](#contents)

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


### Referencing other config items [&#x219F;](#contents)

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
