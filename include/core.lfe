(defmacro get-in args
  (let ((cfg-type (car args))
        (keys (cdr args)))
    `(apply 'lutil-type
            'get-in
            (list (lcfg-file:get-config ,cfg-type) (list ,@keys)))))

(defun loaded-lcfg-core ()
  "This is just a dummy function for display purposes when including from the
  REPL (the last function loaded has its name printed in stdout).

  This function needs to be the last one in this include."
  'ok)

