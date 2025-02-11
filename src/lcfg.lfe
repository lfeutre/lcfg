(defmodule lcfg
  (export all))

(defun version ()
  (lcfg-vsn:get))

(defun versions ()
  (lcfg-vsn:all))
