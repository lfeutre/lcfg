(defmodule lcfg-maps
  (export
   (filter-empty 1)
   (from-list-nested 1)
   (merge 2)
   (merge-nested 2)))

(defun filter-empty (maps)
  (lists:filter (lambda (x) (> (map_size x) 0)) maps))

(defun from-list-nested (proplist)
  (epl:to_map proplist))

(defun merge (map1 map2)
  (maps:merge map1 map2))

(defun merge-nested (map1 map2)
  (maps:fold
   (lambda (k v m)
     (maps:update_with k (lambda (x) v) v m))
   map1
   map2))
