(defmodule lcfg
  (export all))

(defun appenv (app-atom)
  (epl:to_map (application:get_all_env app-atom)))

(defun version ()
  (lcfg-vsn:get))

(defun versions ()
  (lcfg-vsn:all))
