(defmodule lcfg
  (export all))

;; Defaults

(defun default-precedence (app-atom)
  ;; ordering is least-significant to most; in other words, data sources further
  ;; down the list override prior items, towards the top of the list.
  `(#(env ,app-atom)
    #(file ,(lcfg-file:full-path app-atom ".toml"))
    #(file ,(lcfg-file:full-path app-atom ".lfe"))
    #(file ,(lcfg-file:full-path app-atom ".config"))
    #(file ,(++ "./" (lcfg-file:file-name app-atom ".toml")))
    #(file ,(++ "./" (lcfg-file:file-name app-atom ".lfe")))
    #(file ,(++ "./" (lcfg-file:file-name app-atom ".config")))))

(defun default-options ()
  #m(app undefined
     use-all false
     use-env true
     use-first true))

;; API

(defun appenv (app-atom)
  (lcfg-maps:from-list-nested (application:get_all_env app-atom)))

(defun file (filename app-atom)
  (read filename `#m(app ,app-atom)))

(defun load (app-atom)
  (load app-atom (default-options) (default-precedence app-atom)))

(defun load (app-atom opts precedence)
  (load (lcfg-maps:merge opts `#m(app ,app-atom)) precedence))

(defun load
  (((= `#m(app ,app-atom use-first true use-env true) opts) precedence)
   (lcfg-maps:merge-nested (list (appenv app-atom) (load-first opts precedence))))
  (((= `#m(app ,app-atom use-all true) opts) precedence)
   (lcfg-maps:merge-nested (load-all opts precedence))))

(defun load-first (opts precedence)
  (case (load-all opts precedence)
    ('() #m())
    (maps (car maps))))

(defun load-all
  (((= `#m(app ,app-atom) opts) precedence)
   (lcfg-maps:filter-empty
    (list-comp ((<- x precedence)) (load-one app-atom x opts)))))

(defun load-one
  ((_app-atom `#(env ,app-atom) (= `#m(use-env true) _opts))
   (appenv app-atom))
  ((app-atom `#(file ,filename) _opts)
   (case (file filename app-atom)
     (`#(error ,_) #m())
     (data data)))
  ((_ _ _)
   #m()))

(defun read (filename)
  (read #m()))

(defun read (filename opts)
  (lcfg-file:read filename (maps:merge (default-options)
                                       opts)))

(defun show-paths (app-atom)
  (list-comp ((<- `#(file ,filename) (lists:reverse (default-precedence app-atom))))
    (io:format "~p~n" (list filename)))
  'ok)

;; Utility functions

(defun copy (source app-atom)
  (let ((path (lcfg-file:dest-path source app-atom)))
    `#m(result ,(file:copy source path)
        path ,path)))

(defun move (source app-atom)
  (let ((path (lcfg-file:dest-path source app-atom)))
    `#m(result ,(file:rename source path)
        path ,path)))

;; OTP convenience functions

(defun start ()
  (application:ensure_all_started 'lcfg))

;; Metadata

(defun version ()
  (lcfg-vsn:get))

(defun versions ()
  (lcfg-vsn:all))
