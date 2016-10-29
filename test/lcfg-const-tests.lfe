(defmodule lcfg-const-tests
  (behaviour ltest-unit))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest constants
  (is-equal "lfe.config" (lcfg-const:config-file))
  (is-equal "~/.lfe/lfe.config" (lcfg-const:global-config))
  (is-equal "lfe.config" (lcfg-const:local-config))
  (is-equal "deps" (lcfg-const:deps-dir))
  (is-equal "https://github.com/" (lcfg-const:github)))
