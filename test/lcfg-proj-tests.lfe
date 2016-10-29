(defmodule lcfg-proj-tests
  (behaviour ltest-unit))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest get-project-empty
  (is-equal '() (lcfg-proj:get-project 'undefined)))

(deftest get-project-no-project
  (is-equal '() (lcfg-proj:get-project '(#(lfe (#(opt-1 1)))))))

(deftest get-project-no-deps
  (is-equal '() (lcfg-proj:get-project '(#(project ())))))

(deftest get-project-no-deps-with-other
  (is-equal '(#(opt-1 1))
            (lcfg-proj:get-project '(#(project (#(opt-1 1)))))))

(deftest get-project-with-deps-with-other
  (is-equal '(#(deps ("a" "b")))
            (lcfg-proj:get-project '(#(lfe (#(opt-1 1)))
                                     #(project (#(deps ("a" "b"))))))))
