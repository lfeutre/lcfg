(defmodule lcfg-file
  (export
   (read 2)))

(defun read
  ((filename (= `#m(app ,app-atom) opts))
   (let ((data (case (filename:extension filename)
                 (".config" (read-erlang filename opts))
                 (".lfe" (read-lfe filename opts))
                 (".toml" (read-toml filename opts))
                 (_ #(error unsupported-format)))))
     (case data
       (`#(ok ,data) (mref (epl:to_map data) app-atom))
       (`#(ok-map ,data) (bombadil:get data app-atom))
       (err err)))))

(defun read-erlang (filename _opts)
  (case (file:consult filename)
    (`#(ok (,data)) `#(ok ,data))
    (err err)))

(defun read-lfe (filename _opts)
  (case (lfe_io:read_file filename)
    (`#(ok (,data)) `#(ok ,data))
    (err err)))

(defun read-toml (filename _opts)
  (case (bombadil:read filename)
    (`#(ok ,data) `#(ok-map ,data))
    (err err)))
