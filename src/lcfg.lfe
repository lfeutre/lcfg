(defmodule lcfg
  (export all))

(defun default-precedence (app-atom)
  ;; ordering is least-significant to most; in other words, data sources further
  ;; down the list override prior items, towards the top of the list.
  (let ((app-str (atom_to_list app-atom)))
    `(#(env app-atom)
      #(file ,(filename:join (list (dirs:config) app-str "config" (++ app-str ".toml"))))
      #(file ,(filename:join (list (dirs:config) app-str "config" (++ app-str ".lfe"))))
      #(file ,(filename:join (list (dirs:config) app-str "config" (++ app-str ".config"))))
      #(file ,(++ "./" app-str ".toml"))
      #(file ,(++ "./" app-str ".lfe"))
      #(file ,(++ "./" app-str ".config")))))

(defun appenv (app-atom)
  (epl:to_map (application:get_all_env app-atom)))

(defun file (filename app-atom)
  (read filename `#m(app ,app-atom)))

(defun read (filename opts)
  (lcfg-file:read filename opts))
  
(defun start ()
  (application:ensure_all_started 'lcfg))

(defun version ()
  (lcfg-vsn:get))

(defun versions ()
  (lcfg-vsn:all))
