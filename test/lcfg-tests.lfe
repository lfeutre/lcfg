(defmodule lcfg-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest get-not-present
  (is-equal 'undefined (lcfg:get 'key-2 '(#(key-1 val-1)))))

(deftest update
  (is-equal '(#(key-1 new-val) #(key-2 val-2))
            (lcfg:update 'key-1 'new-val '(#(key-1 val-1) #(key-2 val-2))))
  (is-equal '(#(key-1 val-1) #(key-2 new-val))
            (lcfg:update 'key-2 'new-val '(#(key-1 val-1) #(key-2 val-2))))
  (is-equal '(#(key-1 val-1) #(key-2 val-2))
            (lcfg:update 'key-3 'new-val '(#(key-1 val-1) #(key-2 val-2)))))