(defmodule lcfg-util
  (export all))

(include-lib "lutil/include/core.lfe")

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
