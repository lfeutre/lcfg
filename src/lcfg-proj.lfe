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

(defun get-name ()
  (get-in (lcfg-proj:get-project-config) 'meta 'name))

(defun get-description ()
  (get-in (lcfg-proj:get-project-config) 'meta 'description))

(defun get-version ()
  (get-in (lcfg-proj:get-project-config) 'meta 'version))

(defun get-id ()
  (get-in (lcfg-proj:get-project-config) 'meta 'id))

(defun get-keywords ()
  (get-in (lcfg-proj:get-project-config) 'meta 'keywords))

(defun get-maintainers ()
  (get-in (lcfg-proj:get-project-config) 'meta 'maintainers))

(defun get-repos ()
  (get-in (lcfg-proj:get-project-config) 'meta 'repos))

;; For use with complete configuration data
(defun get-name (config)
  (get-in config 'project 'meta 'name))

(defun get-description (config)
  (lcfg-util:set-default
    (get-in config 'project 'meta 'description) ""))

(defun get-version (config)
  (lcfg-util:set-default
    (get-in config 'project 'meta 'version) ""))

(defun get-id (config)
  (lcfg-util:set-default
    (get-in config 'project 'meta 'id) ""))

(defun get-keywords (config)
  (get-in config 'project 'meta 'keywords))

(defun get-maintainers (config)
  (get-in config 'project 'meta 'maintainers))

(defun get-repos (config)
  (get-in config 'project 'meta 'repos))
