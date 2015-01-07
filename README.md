# lcfg

<a href="resources/images/Illustration_Ficus_carica0.jpg"><img src="resources/images/Illustration_Ficus_carica0-small.jpg"/></a>


## Table of Contents

* [Introduction](#introduction-)
* [Dependencies](#dependencies-)
* [Usage](#usage-)
  * ``[project](#project-)``
    * ``[deps](#deps-)``


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
