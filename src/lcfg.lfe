(defmodule lcfg
  (export all))

(defun appenv (app-atom)
  (epl:to_map (application:get_all_env app-atom)))

(defun file (filename app-atom)
  (read filename `#m(app ,app-atom)))

(defun read (filename opts)
  (lcfg-file:read filename opts))
  
(defun start ()
  (application:ensure_all_started 'lcfg))

(defun version ()
  (lcfg-vsn:get))

(defun versions ()
  (lcfg-vsn:all))
