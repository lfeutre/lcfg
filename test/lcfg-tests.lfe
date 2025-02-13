(defmodule lcfg-tests
  (behaviour ltest-unit))

(include-lib "ltest/include/ltest-macros.lfe")

#| Markdown

# Notes on testing for Erlang app environment data

An application with configuration data such as the following:

```erlang
[{tasker,
  [{tasks, [[{name, "Example Task (regular date check)"},
             {cmd, "date"},
             {args, []},
             {interval, 4}],
            [{name, "Example Task (regular test message)"},
             {cmd, "echo"},
             {args, ["this is a test"]},
             {interval, 10}],
            [{name, "Example Task (remote command)"},
             {cmd, "ssh"},
             {args, ["raspberrypi.local", "-C", "'uname -a'"]},
             {interval, 20}]]
  }]
}].
```

will, once the application has been successfully started, will have the
following environment data when one calls the `get_all_env` function:

```erlang
1> application:get_all_env(tasker).
[{tasks,[[{name,"Example Task (regular date check)"},
          {cmd,"date"},
          {args,[]},
          {interval,4}],
         [{name,"Example Task (regular test message)"},
          {cmd,"echo"},
          {args,["this is a test"]},
          {interval,10}],
         [{name,"Example Task (remote command)"},
          {cmd,"ssh"},
          {args,["raspberrypi.local","-C","'uname -a'"]},
          {interval,20}]]}]
```

This library normalises the return values from application configuration, and as
such, attempts to produce results that follow the same general approach used by
Erlang/OTP, namely using the application name as the key in a key/value lookup of
configuration data.

Note, however, that it does normalise all of these to the Erlang map data
structure.
|#
(deftest appenv
  (lcfg:start)
  (let ((result (lcfg:appenv 'lcfg))) 
    (is-equal 'value1 (clj:get-in result '(example1 key1)))
    (is-equal 'value2 (clj:get-in result '(example1 key2)))
    (is-equal 'value3 (clj:get-in result '(example2 key3)))))

(deftest file-erlang
  (lcfg:start)
  (let ((result (lcfg:file "priv/examples/erlang.config" 'lcfg)))
    (is-equal 'value1 (clj:get-in result '(example1 key1)))
    (is-equal 'value2 (clj:get-in result '(example1 key2)))
    (is-equal 'value3 (clj:get-in result '(example2 key3)))
    (is-equal 'value4 (clj:get-in result '(example3 example4 key4)))))

(deftest file-lfe
  (lcfg:start)
  (let ((result (lcfg:file "priv/examples/config.lfe" 'lcfg)))
    (is-equal 'value-1 (clj:get-in result '(example-1 key-1)))
    (is-equal 'value-2 (clj:get-in result '(example-1 key-2)))
    (is-equal 'value-3 (clj:get-in result '(example-2 key-3)))
    (is-equal 'value-4 (clj:get-in result '(example-3 example-4 key-4)))))

(deftest file-toml
  (lcfg:start)
  (let ((result (lcfg:file "priv/examples/config.toml" 'lcfg)))
    (is-equal #"value1" (bombadil:get-in result '(example1 key1)))
    (is-equal #"value2" (bombadil:get-in result '(example1 key2)))
    (is-equal #"value3" (bombadil:get-in result '(example2 key3)))
    (is-equal #"value4" (bombadil:get-in result '(example3 example4 key4)))))
