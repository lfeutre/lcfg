;;;; This provides support for generating relx.config files from the
;;;; lfe.config file.
;;;;
;;;; The definitive relx.config sample:
;;;;   https://github.com/erlware/relx/blob/master/examples/relx.config
;;;;
(defmodule lcfg-relx
  (export all))

(include-lib "lutil/include/core.lfe")
(include-lib "lutil/include/compose.lfe")
(include-lib "lutil/include/predicates.lfe")

(defun write ()
  (write "relx.config"))

(defun write (out-file)
  (write (lcfg:get-in `(,(lcfg-relx:get-data)) '(relx)) out-file))

(defun write (config out-file)
  (let ((`#(ok ,fh) (file:open out-file '(write))))
    (lists:map (lambda (line) (io:fwrite fh "~p.~n" `(,line)))
               config)))

(defun get-data ()
  (get-data (lcfg-file:parse)))

(defun get-data
  (('undefined)
   #(relx ()))
  (('())
   #(relx ()))
  ((config)
   (case (lcfg:get 'relx config)
     ('undefined `#(relx ,(extract-relx-data config)))
     ('() `#(relx ,(extract-relx-data config)))
     (result `#(relx ,(add-defaults result config))))))

(defun extract-relx-data (config)
  (->> `(,(get-paths config)
         ,(get-vm-args config)
         ,(get-sys-config config)
         ,(get-include-erts config)
         ,(get-extended-start-script config)
         ,(get-default-release config)
         ,(get-release config)
         ,(get-overrides config)
         ,(get-overlay-vars config)
         ,(get-overlay config)
         ,(get-lib-dirs config)
         ,(get-providers config))
       (filter-non-tuples)
       (filter-undefined)))

(defun add-defaults (relx config)
  (-> relx
      (add-release config)
      ;; add more here
      ))

(defun add-release (relx config)
  (if (has-release? config)
    relx
    (++ relx `(,(get-release config)))))

(defun filter-non-tuples (data)
  (lists:filter (lambda (x) (tuple? x)) data))

(defun filter-undefined (data)
  (lists:filter (lambda (x) (not (undefined? (element 2 x)))) data))

(defun get
  (((= `(relx ,key) keys) default config)
  `#(,key ,(lcfg:get-in config default keys))))

(defun get-paths (config)
  (get '(relx paths) 'undefined config))

(defun get-vm-args (config)
  (get '(relx vm_args) 'undefined config))

(defun get-sys-config (config)
  (get '(relx sys_config) 'undefined config))

(defun get-include-erts (config)
  (get '(relx include_erts) 'true config))

(defun get-extended-start-script (config)
  (get '(relx extended_start_script) 'false config))

(defun get-default-release (config)
  (case (has-default-release? config)
    ('false #(default_release undefined))
    (result result)))

(defun get-release (config)
  (case (has-release? config)
    ('false (generate-release-options config))
    (release release)))

(defun has-key? (key config)
  (case (lists:keyfind key 1 (lcfg:get-in config '(relx)))
    ('undefined 'false)
    ('() 'false)
    ('false 'false)
    (_ 'true)))

(defun has-default-release? (config)
  (has-key? 'default-release config))

(defun has-release? (config)
  (has-key? 'release config))

(defun generate-release-options (config)
  (let ((results (-generate-release-options config)))
    (case results
      (`#(release ,data ())
       `#(release ,data))
      (_ results))))

(defun -generate-release-options (config)
  (let ((name (lcfg-proj:get-name config)))
    `#(release #(,name
                 ,(lcfg-proj:get-version config))
               ,(++ `(,name)
                    (lcfg-appsrc:get-applications config)))))

(defun get-overrides (config)
  (get '(relx overrides) 'undefined config))

(defun get-providers (config)
  (get '(relx add_providers) 'undefined config))

(defun get-overlay-vars (config)
  (get '(relx overlay_vars) 'undefined config))

(defun get-overlay (config)
  (get '(relx overlay) 'undefined config))

(defun get-lib-dirs (config)
  (get '(relx add_lib_dirs) '() config))


