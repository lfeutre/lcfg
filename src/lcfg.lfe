(defmodule lcfg
  (export all))

(defun clone-deps ()
  (lcfg-deps:clone-deps))

(defun get-in (args)
  (get-in 'local args))

(defun get-in
  (('undefined _)
   '())
  ((config '())
   config)
  (('local args)
    (lutil-type:get-in (lcfg-file:read-local) args))
  (('global args)
    (lutil-type:get-in (lcfg-file:read-global) args))
  ((config args)
    (lists:foldl #'get/2 config args)))

(defun get (key data)
  (let ((result (lists:keyfind key 1 data)))
    (case result
      ('false '())
      (_ (element 2 result)))))
