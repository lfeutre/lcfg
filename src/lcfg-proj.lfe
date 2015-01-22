(defmodule lcfg-proj
  (export all))

(include-lib "lutil/include/core.lfe")

(defun get-project-config ()
  (let ((local (get-local-project)))
    (if (=/= local '())
        local
        (get-globgal-project))))

(defun get-local-project ()
  (get-project (lcfg-file:parse-local)))

(defun get-globgal-project ()
  (get-project (lcfg-file:parse-global)))

(defun get-project
  (('())
    '())
  ((config)
    (get-in config 'project)))

(defun get-keywords ()
  (get-in (lcfg-proj:get-project-config) 'meta 'keywords))

(defun get-maintainers ()
  (get-in (lcfg-proj:get-project-config) 'meta 'maintainers))

(defun get-repos ()
  (get-in (lcfg-proj:get-project-config) 'meta 'repos))
