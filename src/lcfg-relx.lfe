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
  (get-data (lcfg-file:parse-local)))

(defun get-data
  (('undefined)
   #(relx ()))
  (('())
   #(relx ()))
  ((config)
   (case (lcfg:get 'relx config)
     ('undefined `#(relx ,(extract-relx-data config)))
     ('() `#(relx ,(extract-relx-data config)))
     (result `#(relx ,result)))))

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
         ,(get-providers config))
       (filter-non-tuples)
       (filter-undefined)))

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
  (case (lists:keyfind 'default_release 1 (lcfg:get-in config '(relx)))
    ('false #(default_release undefined))
    (result result)))

(defun get-release (config)
  (case (lists:keyfind 'release 1 (lcfg:get-in config '(relx)))
    ('false (generate-release-options config))
    ('undefined (generate-release-options config))
    ('() (generate-release-options config))
    (release release)))

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
                    (lcfg-appsrc:get-applications config)
                    (lcfg-util:get-rebarcfg-dep-names name)))))

(defun get-overrides (config)
  (get '(relx overrides) 'undefined config))

(defun get-providers (config)
  (get '(relx add_providers) 'undefined config))

(defun get-overlay-vars (config)
  (get '(relx overlay_vars) 'undefined config))

(defun get-overlay (config)
  (get '(relx overlay) 'undefined config))
