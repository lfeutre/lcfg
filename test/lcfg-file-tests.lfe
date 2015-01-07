(defmodule lcfg-file-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from ltest
      (check-failed-is 2)
      (check-wrong-is-exception 2))))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest check-contents
  (is-equal '(#(a 1) #(b 2)) (lutil-cfg:check-contents '(#(a 1) #(b 2)))))

(deftest check-contents-fail-content-check
  (try
    (progn
      (lutil-cfg:check-contents '(1 #(b 2)))
      (error 'unexpected-test-success))
    (catch (`#(,type ,value ,_)
      (is-equal 'error type)
      (is-equal
        "Every top-level item in an lfe.config file needs to be a tuple."
        value)))))
