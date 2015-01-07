(defmodule lcfg-proj
  (export all))

(defun get-project
  (('())
    '())
  ((config)
    (proplists:get_value 'project config '())))
