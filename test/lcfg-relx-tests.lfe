(defmodule lcfg-relx-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest get-relx-config-undefined
  (is-equal #(relx ()) (lcfg-relx:get-data 'undefined)))

(deftest get-relx-config-empty
  (is-equal #(relx ()) (lcfg-relx:get-data '())))

(deftest get-relx-default
  (is-equal #(relx (#(include-erts true)
                    #(extended-start-script false)
                    #(release #(test ()) (test))
                    #(add-lib-dirs ())))
            (lcfg-relx:get-data '(#(project (#(meta (#(name test)))))
                                  #(relx ())))))
