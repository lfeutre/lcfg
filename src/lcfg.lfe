(defmodule lcfg
  (export all))

(defun clone-deps ()
  (lcfg-deps:clone-deps))

(defun get-in (args)
  (get-in 'local args))

(defun get-in
  ((_ 'undefined)
   '())
  (('() config)
   config)
  (('local args)
    (lutil-type:get-in (lcfg-file:read-local) args))
  (('global args)
    (lutil-type:get-in (lcfg-file:read-global) args))
  ((config args)
    (lists:foldl #'get/2 config args)))

(defun get-in (data default args)
  (let ((result (get-in args data)))
    (case result
      ('false default)
      ('undefined default)
      (_ result))))

(defun get (key config)
  (let ((result (lists:keyfind key 1 config)))
    (case result
      ('false 'undefined)
      (_ (element 2 result)))))

(defun get (key default config)
  (let ((result (get key config)))
    (case result
      ('false default)
      ('undefined default)
      (_ result))))

(defun update (key value)
  (update key value (lcfg-file:read-local)))

(defun update (key value config)
  (++ `(#(,key ,value))
      (lists:keydelete key 1 config)))
