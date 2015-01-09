(defmodule lcfg-util
  (export all))

(defun get-version ()
  (lutil:get-app-version 'lcfg))

(defun get-versions ()
  (++ (lutil:get-versions)
      `(#(lcfg ,(get-version)))))
