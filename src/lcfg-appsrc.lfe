(defmodule lcfg-appsrc
  (export all))

(include-lib "lutil/include/core.lfe")

(defun write (out-file)
  (write (get-data) out-file))

(defun write (config out-file)
  (let ((`#(ok ,fh) (file:open out-file '(write))))
    (io:fwrite fh "~p.~n" `(,config))))

(defun get-data ()
  (get-data (lcfg-file:parse-local)))

(defun get-data (config)
  `#(application ,(lcfg-proj:get-name config)
     (#(description ,(lcfg-proj:get-description config))
      #(id ,(lcfg-proj:get-id config))
      #(vsn ,(lcfg-proj:get-version config))
      #(modules ,(get-modules config))
      #(maxT ,(get-max-t config))
      #(registered ,(get-registered config))
      #(included_applications ,(get-included-applications config))
      #(applications ,(get-applications config))
      #(env ,(get-env config))
      #(mod ,(get-mod config))
      #(start_phases ,(get-start-phases config))
      ;; runtime_dependencies will be skipped until it's declared
      ;; as stabilized by the OTP team
      ;;#(runtime_dependencies ,(lutil-type:get-in config 'project 'app 'runtime-dependencies))
      )))

(defun get-modules (config)
  (lcfg-util:set-default
    (lutil-type:get-in config '(project app modules))
    (lists:map
      #'list_to_atom/1
      (lcfg-util:get-source-files 'no-extensions))))

(defun get-max-t (config)
  (lcfg-util:set-default
    (lutil-type:get-in config '(project app max-t))
    'infinity))

(defun get-registered (config)
  (lcfg-util:set-default
    (lutil-type:get-in config '(project app registered))
    '()))

(defun get-included-applications (config)
  (lcfg-util:set-default
    (lutil-type:get-in config '(project app included-applications))
    '()))

(defun get-applications (config)
  (lcfg-util:set-default
    (lutil-type:get-in config '(project app applications))
    '()))

(defun get-env (config)
  (lcfg-util:set-default
    (lutil-type:get-in config '(project app env))
    '()))

(defun get-mod (config)
  (lcfg-util:set-default
    (lutil-type:get-in config '(project app mod))
    '()))

(defun get-start-phases (config)
  (lcfg-util:set-default
    (lutil-type:get-in config '(project app start-phases))
    'undefined))
