(defmodule lcfg-util
  (export all))

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

(defun strip-extensions (files)
  (lists:map #'filename:rootname/1 files))

(defun load-appsrc (app-atom)
  (let* ((filename (filename:flatten `(,app-atom .app)))
         (fullpath (code:where_is_file filename))
         (`#(ok ,data) (file:consult fullpath)))
    data))

(defun get-appsrc-name (app-atom)
  (lcfg:get 'application (load-appsrc app-atom)))

(defun get-appsrc-data (app-atom)
  (caddr (tuple_to_list (car (load-appsrc 'lcfg)))))

(defun get-appsrc-version (app-atom)
  (lcfg:get 'vsn (get-appsrc-data app-atom)))

(defun get-appsrc-applications (app-atom)
  (lcfg:get 'applications (get-appsrc-data app-atom)))