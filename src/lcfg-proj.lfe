(defmodule lcfg-proj
  (export all))

(include-lib "lutil/include/core.lfe")

(defun get-project-config ()
  (let ((local (get-local-project)))
    (if (=/= local '())
        local
        (get-global-project))))

(defun get-local-project ()
  (get-project (lcfg-file:parse-local)))

(defun get-global-project ()
  (get-project (lcfg-file:parse-global)))

(defun get-project
  (('())
    '())
  ((config)
    (lcfg:get-in config '(project))))

(defun get-name ()
  (lcfg:get-in (get-project-config) '(meta name)))

(defun get-description ()
  (lcfg:get-in (get-project-config) '(meta description)))

(defun get-version ()
  (lcfg:get-in (get-project-config) '(meta version)))

(defun get-id ()
  (lcfg:get-in (get-project-config) '(meta id)))

(defun get-keywords ()
  (lcfg:get-in (get-project-config) '(meta keywords)))

(defun get-maintainers ()
  (lcfg:get-in (get-project-config) '(meta maintainers)))

(defun get-repos ()
  (lcfg:get-in (get-project-config) '(meta repos)))

;; For use with complete configuration data
(defun get-name (config)
  ;; XXX
  (io:format "DEBUG: config: ~p~n" (list config))
  (lcfg:get-in config '(project meta name)))

(defun get-description (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(project meta description)) ""))

(defun get-version (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(project meta version)) ""))

(defun get-id (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(project meta id)) ""))

(defun get-keywords (config)
  (lcfg:get-in config '(project meta keywords)))

(defun get-maintainers (config)
  (lcfg:get-in config '(project meta maintainers)))

(defun get-repos (config)
  (lcfg:get-in config '(project meta repos)))
