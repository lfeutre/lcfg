(defmodule lcfg-tests
  (behaviour ltest-unit))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest placeholder
  (is-equal 1 1))
