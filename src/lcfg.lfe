(defmodule lcfg
  (export all))

(defun appenv (app-atom)
  (maps:from_list (application:get_all_env app-atom)))

(defun version ()
  (lcfg-vsn:get))

(defun versions ()
  (lcfg-vsn:all))
