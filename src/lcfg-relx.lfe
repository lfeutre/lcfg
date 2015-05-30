;;;; This provides support for generating relx.config files from the
;;;; lfe.config file.
;;;;
(defmodule lcfg-relx
  (export all))

(include-lib "lutil/include/core.lfe")

(defun write ()
  (write "relx.config"))

(defun write (out-file)
  (write (lcfg:get-in `(,(lcfg-relx:get-data)) '(relx)) out-file))

(defun write (config out-file)
  (let ((`#(ok ,fh) (file:open out-file '(write))))
    (lists:map (lambda (line) (io:fwrite fh "~p.~n" `(,line)))
               config)))

(defun get-data ()
  (get-data (lcfg-file:parse-local)))

(defun get-data (config)
  `#(relx
     (#(paths ,(get-paths config))
      #(vm_args ,(get-vm-args config))
      #(sys_config ,(get-sys-config config))
      #(include_erts ,(get-include-erts config))
      #(extended_start_script ,(get-extended-start-script config))
      #(default_release ,(lcfg-proj:get-name)
                        ,(get-default-release config))
      #(release ,@(get-release config))
      #(overrides ,(get-overrides config))
      #(overlay_vars ,(get-overlay-vars config))
      #(overlay ,(get-overlay config))
      #(add_providers ,(get-providers config)))))

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
  (cdr
   (tuple_to_list
    (lists:keyfind 'release 1 (lcfg:get-in (lcfg-file:parse-local) '(relx))))))

(defun get-overrides (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx overrides))
    'undefined))

(defun get-providers (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx add_providers))
    'undefined))

(defun get-overlay-vars (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx overlay_vars))
    'undefined))

(defun get-overlay (config)
  (lcfg-util:set-default
    (lcfg:get-in config '(relx overlay))
    'undefined))