(defmodule lcfg-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest get-not-present
  (is-equal 'undefined (lcfg:get 'key-2 '(#(key-1 val-1)))))
