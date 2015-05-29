(defmodule lcfg
  (export all))

(defun clone-deps ()
  (lcfg-deps:clone-deps))

(defun get-in (args)
  (get-in 'local args))

(defun get-in
  (('local args)
    (lutil-type:get-in (lcfg-file:read-local) args))
  (('global args)
    (lutil-type:get-in (lcfg-file:read-global) args)))
