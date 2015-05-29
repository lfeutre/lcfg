;;;; This provides support for generating relx.config files from the
;;;; lfe.config file.
;;;;
(defmodule lcfg-relx
  (export all))

(include-lib "lutil/include/core.lfe")

(defun write ()
  (write "relx.config"))

(defun write (out-file)
  (write (get-data) out-file))

(defun write (config out-file)
  (let ((`#(ok ,fh) (file:open out-file '(write))))
    (io:fwrite fh "~p.~n" `(,config))))

(defun get-data ()
  (get-data (lcfg-file:parse-local)))

(defun get-data (config)
  `#(relx
     (#(paths ,(get-paths config))
      #(vm_args ,(get-vm-args config))
      #(sys_config ,(get-sys-config config))
      #(include_erts ,(get-include-erts config))
      #(extended_start_script ,(get-extended-start-script config))
      #(default_release sexpr ,(get-default-release config))
      #(release ,(get-release config))
      #(overrides ,(get-overrides config)))))

(defun get-paths (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx paths))
    'undefined))

(defun get-vm-args (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx vm_args))
    'undefined))

(defun get-sys-config (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx sy_config))
    'undefined))

(defun get-include-erts (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx include_erts))
    'true))

(defun get-extended-start-script (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx extended_start_script))
    'false))

(defun get-default-release (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx default_release))
    'undefined))

(defun get-release (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx release))
    'undefined))

(defun get-overrides (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx overrides))
    'undefined))