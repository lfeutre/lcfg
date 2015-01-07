(defmodule lcfg-deps-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from ltest
      (check-failed-is 2)
      (check-wrong-is-exception 2))))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest merge-deps-empty
  (is-equal '() (lcfg-deps:merge-deps '() '())))

(deftest merge-deps-only-one
  (is-equal '("a" "b")
            (lcfg-deps:merge-deps
              '(#(project (#(deps ("a" "b")))))
              '()))
  (is-equal '(1 2)
            (lcfg-deps:merge-deps
              '()
              '(#(project (#(deps (1 2))))))))

(deftest merge-deps-no-shared
  (is-equal '("a" "b" 1 2)
            (lcfg-deps:merge-deps
              '(#(project (#(deps ("a" "b")))))
              '(#(project (#(deps (1 2)))))))
  (is-equal '(#("a/b" "c") "d/e" #("f/g" "h") "i/j")
            (lcfg-deps:merge-deps
              '(#(project (#(deps (#("a/b" "c") "d/e")))))
              '(#(project (#(deps (#("f/g" "h") "i/j"))))))))

(deftest merge-deps-some-shared
  (is-equal '("a" "b" "c")
            (lcfg-deps:merge-deps
              '(#(project (#(deps ("a" "b")))))
              '(#(project (#(deps ("b" "c")))))))
  (is-equal '("d/e" #("a/b" "c") "i/j")
            (lcfg-deps:merge-deps
              '(#(project (#(deps (#("a/b" "c") "d/e")))))
              '(#(project (#(deps (#("a/b" "c") "i/j")))))))
  (is-equal '("d/e" #("a/b" "f") "i/j")
            (lcfg-deps:merge-deps
              '(#(project (#(deps (#("a/b" "c") "d/e")))))
              '(#(project (#(deps (#("a/b" "f") "i/j")))))))
  (is-equal '("d/e" #("a/b" "c") "i/j")
            (lcfg-deps:merge-deps
              '(#(project (#(deps (#("a/b" "f") "d/e")))))
              '(#(project (#(deps (#("a/b" "c") "i/j")))))))
  (is-equal '(#("a/b" "c") #("f/g" "h") "d/e")
            (lcfg-deps:merge-deps
              '(#(project (#(deps (#("a/b" "c") "d/e")))))
              '(#(project (#(deps (#("f/g" "h") "d/e"))))))))

(deftest merge-deps-all-shared
  (is-equal '("a" "b")
            (lcfg-deps:merge-deps
              '(#(project (#(deps ("a" "b")))))
              '(#(project (#(deps ("a" "b")))))))
  (is-equal '(#("a/b" "c") "d/e")
            (lcfg-deps:merge-deps
              '(#(project (#(deps (#("a/b" "c") "d/e")))))
              '(#(project (#(deps (#("a/b" "c") "d/e"))))))))

(deftest select-deps-no-shared
  (is-equal '("a" "b" 1 2)
            (lutil-cfg:select-deps
              '("a" "b")
              '(1 2)))
  (is-equal '(#("a/b" "c") "d/e" #("f/g" "h") "i/j")
            (lutil-cfg:select-deps
              '(#("a/b" "c") "d/e")
              '(#("f/g" "h") "i/j"))))

(deftest select-deps-some-shared
  (is-equal '("a" "b" "c")
            (lutil-cfg:select-deps
              '("a" "b")
              '("b" "c")))
  (is-equal '("d/e" #("a/b" "c") "i/j")
            (lutil-cfg:select-deps
              '(#("a/b" "c") "d/e")
              '(#("a/b" "c") "i/j")))
  (is-equal '("d/e" #("a/b" "f") "i/j")
            (lutil-cfg:select-deps
              '(#("a/b" "c") "d/e")
              '(#("a/b" "f") "i/j")))
  (is-equal '("d/e" #("a/b" "c") "i/j")
            (lutil-cfg:select-deps
              '(#("a/b" "f") "d/e")
              '(#("a/b" "c") "i/j")))
  (is-equal '(#("a/b" "c") #("f/g" "h") "d/e")
            (lutil-cfg:select-deps
              '(#("a/b" "c") "d/e")
              '(#("f/g" "h") "d/e"))))

(deftest select-deps-all-shared
  (is-equal '("a" "b")
            (lutil-cfg:select-deps
              '("a" "b")
              '("a" "b")))
  (is-equal '(#("a/b" "c") "d/e")
            (lutil-cfg:select-deps
              '(#("a/b" "c") "d/e")
              '(#("a/b" "c") "d/e"))))

(deftest get-repo
  (is-equal "a/b" (lutil-cfg:get-repo "a/b"))
  (is-equal "a/b" (lutil-cfg:get-repo #("a/b" "master")))
  (is-equal "a/b" (lutil-cfg:get-repo #("a/b" "develop"))))

(deftest get-deps-empty
  (is-equal '() (lcfg-deps:get-deps '())))

(deftest get-deps-no-deps
  (is-equal '() (lcfg-deps:get-deps '(#(deps ())))))

(deftest get-deps-no-deps-with-other
  (is-equal '() (lcfg-deps:get-deps '(#(opts (#(opt-1 1)))))))

(deftest get-deps
  (is-equal '("a" "b") (lcfg-deps:get-deps '(#(deps ("a" "b"))))))

(deftest get-deps-with-other
  (is-equal '("a" "b") (lcfg-deps:get-deps '(#(opts (#(opt-1 1)))
                                                     #(deps ("a" "b"))))))
