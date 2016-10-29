(defmodule lcfg-hexpm
  (export all))

(defun get-pkg-name ()
  (lcfg:get-in (lcfg-proj:get-project-config) '(hexpm name)))

(defun get-licenses ()
  (lcfg:get-in (lcfg-proj:get-project-config) '(hexpm licenses)))

(defun get-maintainers ()
  (lcfg:get-in (lcfg-proj:get-project-config) '(hexpm maintainers)))

(defun get-links ()
  (lcfg:get-in (lcfg-proj:get-project-config) '(hexpm links)))

;; For use with complete configuration data
(defun get-pkg-name (config)
  (lcfg:get-in config '(name)))

(defun get-licenses (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(licenses)) '()))

(defun get-maintainers (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(maintainers)) '()))

(defun get-links (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(links)) '()))

(defun ->appsrc (config)
  `(#(pkg_name (get-pkg-name config))
    #(maintainers (get-maintainers config))
    #(licenses (get-licenses config))
    #(links (get-links config))))
