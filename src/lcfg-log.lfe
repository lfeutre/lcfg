;;;; This provides support for setting up logging systems from the
;;;; lfe.config file. Note, however, that you will need to ensure that
;;;; your preferred logging system is available (e.g., as a dependency
;;;; in your rebar.config or lfe.config file).
;;;;
(defmodule lcfg-log
  (export all))

(defun setup ()
  (setup (get-logging-config)))

(defun setup (config)
  (case (proplists:get_value 'backend config)
    ('lager (setup-lager config))))

(defun get-logging-config ()
  (let ((local (get-local-logging)))
    (if (=/= local '())
        local
        (get-globgal-logging))))

(defun get-local-logging ()
  (get-logging (lcfg-file:parse-local)))

(defun get-globgal-logging ()
  (get-logging (lcfg-file:parse-global)))

(defun get-logging
  (('())
    '())
  ((config)
    (proplists:get_value 'logging config '())))

(defun setup-lager (config)
  (application:load 'lager)
  (application:set_env
    'lager
    'handlers
    (proplists:get_value 'options config))
  (lager:start))
