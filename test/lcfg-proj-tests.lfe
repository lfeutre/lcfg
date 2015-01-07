(defmodule lcfg-proj-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from ltest
      (check-failed-is 2)
      (check-wrong-is-exception 2))))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest get-project-empty
  (is-equal '() (lutil-cfg:get-project '())))

(deftest get-project-no-project
  (is-equal '() (lutil-cfg:get-project '(#(lfe (#(opt-1 1)))))))

(deftest get-project-no-deps
  (is-equal '() (lutil-cfg:get-project '(#(project ())))))

(deftest get-project-no-deps-with-other
  (is-equal '(#(opt-1 1))
            (lutil-cfg:get-project '(#(project (#(opt-1 1)))))))

(deftest get-project-with-deps-with-other
  (is-equal '(#(deps ("a" "b")))
            (lutil-cfg:get-project '(#(lfe (#(opt-1 1)))
                                     #(project (#(deps ("a" "b"))))))))
