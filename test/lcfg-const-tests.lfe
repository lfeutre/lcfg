(defmodule lcfg-const-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from ltest
      (check-failed-is 2)
      (check-wrong-is-exception 2))))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest constants
  (is-equal "lfe.config" (lutil-cfg:config-file))
  (is-equal "~/.lfe/lfe.config" (lutil-cfg:global-config))
  (is-equal "lfe.config" (lutil-cfg:local-config))
  (is-equal "deps" (lutil-cfg:deps-dir))
  (is-equal "https://github.com/" (lutil-cfg:github)))
