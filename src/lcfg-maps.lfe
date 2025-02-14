(defmodule lcfg-maps
  (export
   (filter-empty 1)
   (from-list-nested 1)
   (merge 2)
   (merge-nested 1) (merge-nested 2)))

(defun filter-empty (maps)
  (lists:filter (lambda (x) (> (map_size x) 0)) maps))

(defun from-list-nested (proplist)
  (lists:foldl
   (match-lambda
     ((`#(,k ,v) acc) (when (is_list v))
      (case (clj:proplist? v)
        ('false (maps:put k v acc))
        ('true (maps:put k (from-list-nested v) acc))))
     ((`#(,k ,v) acc)
      (maps:put k v acc)))
   #m()
   proplist))

(defun merge (map1 map2)
  (maps:merge map1 map2))

(defun merge-nested (list-of-maps)
  (lists:foldl (lambda (x acc) (merge-nested acc x))
               #m()
               list-of-maps))

(defun merge-nested (map1 map2)
  (maps:fold
   (lambda (k v m)
     (maps:update_with k (lambda (x) v) v m))
   map1
   map2))

