(defmodule lcfg-relx-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest get-relx-config-undefined
  (is-equal #(relx ()) (lcfg-relx:get-data 'undefined)))

(deftest get-relx-config-empty
  (is-equal #(relx ()) (lcfg-relx:get-data '())))

(deftest get-relx-default
  (is-equal #(relx (#(include_erts true)
                    #(extended_start_script false)
                    #(release #(test ()) (test))
                    #(add_lib_dirs ())))
            (lcfg-relx:get-data '(#(project (#(meta (#(name test)))))
                                  #(relx ())))))
