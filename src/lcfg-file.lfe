(defmodule lcfg-file
  (export all))

(include-lib "lutil/include/compose.lfe")

(defun read-config
  ((`#(ok ,config-data))
    (check-contents
      (eval-contents config-data)))
  ;; If the file doesn't exist, let's just return an empty list
  ((`#(error #(none file enoent)))
    '())
  ;; For other errors, let's see what they are
  (((= `#(error ,_) error))
    error)
  ((_)
    '()))

(defun read-global ()
  (->> (lcfg-const:global-config)
       (lutil-file:expand-home-dir)
       (read-file)
       (read-config)))

(defun read-local ()
  (->> (lcfg-const:local-config)
       (filename:join (get-cwd))
       (read-file)
       (read-config)))

(defun read-file (filename)
  (try
    (lfe_io:read_file filename)
    (catch
      ;; Handle zero-byte files
      (`#(error #(,_ #(eof ,_)) ,_)
        '()))))

(defun get-cwd ()
  (let ((`#(ok ,cwd) (file:get_cwd)))
    cwd))

(defun eval-contents (contents)
  "Go line-by-line in the parsed config file and attempt to evaluate it, in
  the event that any functions were called in the config file."
  (lists:map #'lfe_eval:expr/1 contents))

(defun check-contents (contents)
  "This function should be called immediately before the config data is
  passed to (orddict:from_list ...), as it will ensure that each top-level
  item that was parsed is a tuple. This allows the config loaders to render
  a non-gibberish error message to the user."
  (if (lists:all #'is_tuple/1 contents)
      contents
      (error (++ "Every top-level item in an lfe.config file needs "
                 "to be a tuple (or able to be evaluated as a tuple)."))))
