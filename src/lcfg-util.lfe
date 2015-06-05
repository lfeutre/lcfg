(defmodule lcfg-util
  (export all))

(include-lib "lutil/include/compose.lfe")

(defun get-version ()
  (get-app-version 'lcfg))

(defun get-versions ()
  (++ (lutil:get-versions)
      `(#(lcfg ,(get-version)))))

(defun get-app-version
  ((name) (when (is_atom name))
    (let* ((filename (++ (atom_to_list name) ".app"))
           (filepath (code:where_is_file filename)))
      (if (filelib:is_file filepath)
          (get-app-version filepath)
          'undefined)))
  ((`#(ok (,app)))
    (lcfg:get-in (element 3 app) '(vsn)))
  ((filename) (when (is_list filename))
    (get-app-version (file:consult filename))))

;;; DEPRECATED - use lcfg:get/3 and lcfg:get-in/3 instead
(defun set-default (result default)
  (case result
    ('false default)
    ('undefined default)
    ('() default)
    (_ result)))

(defun get-source-files ()
  (get-source-files "./src"))

(defun get-source-files
  (('no-extensions)
    (strip-extensions (get-source-files)))
  ((src-dir)
    (let ((`#(ok ,files) (file:list_dir src-dir)))
      (lists:filter #'source-file?/1 files))))

(defun source-file? (filename)
  (case (re:run filename "^.*\.(lfe|erl|ex|jxa)$")
    (`#(match ,_) 'true)
    (_ 'false)))

(defun get-beam-files ()
  (get-beam-files "./ebin"))

(defun get-beam-files
  (('no-extensions)
    (strip-extensions (get-beam-files)))
  ((src-dir)
    (let ((`#(ok ,files) (file:list_dir src-dir)))
      (lists:filter #'beam-file?/1 files))))

(defun beam-file? (filename)
  (case (re:run filename "^.*\.(beam)$")
    (`#(match ,_) 'true)
    (_ 'false)))

(defun strip-extensions (files)
  (lists:map #'filename:rootname/1 files))

(defun load-appsrc (app-atom)
  (let* ((filename (filename:flatten `(,app-atom .app)))
         (fullpath (code:where_is_file filename))
         (`#(ok ,data) (file:consult fullpath)))
    data))

(defun get-appsrc-name (app-name)
  (lcfg:get 'application (load-appsrc app-name)))

(defun get-appsrc-data (app-name)
  (caddr (tuple_to_list (car (load-appsrc app-name)))))

(defun get-appsrc-version (app-name)
  (lcfg:get 'vsn (get-appsrc-data app-name)))

(defun get-appsrc-applications (app-name)
  (lcfg:get 'applications (get-appsrc-data app-name)))

(defun load-rebarcfg (app-name)
  (let ((`#(ok ,data) (file:consult (get-rebarcfg app-name))))
    data))

(defun get-rebarcfg-deps (app-name)
  (proplists:get_value 'deps (lcfg-util:load-rebarcfg app-name)))

(defun get-appsrc (app-name)
  (let ((filename (filename:flatten `(,app-name .app))))
    (code:where_is_file filename)))

(defun get-appdir (app-name)
  (->> (get-appsrc app-name)
       (filename:dirname)
       (filename:dirname)))

(defun get-rebarcfg (app-name)
  (filename:flatten `(,(get-appdir app-name) / rebar.config)))