(defmodule lcfg-const
  (export all))

(defun config-file () "lfe.config")
(defun global-config () (filename:join "~/.lfe" (config-file)))
(defun local-config () (config-file))
(defun deps-dir () "deps")
(defun github () "https://github.com/")
(defun no-deps () "no dep overrides found in lfe.config")
(defun out-prompt () "lfetool \x00BB;\x2014;> ")
(defun newline () 10)
