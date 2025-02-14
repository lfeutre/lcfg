(defmodule lcfg-maps-tests
  (behaviour ltest-unit))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest filter-empty-all
  (is-equal '()
            (lcfg-maps:filter-empty '(#m() #m() #m()))))

(deftest filter-empty-some
  (is-equal '(#m(a 1) #m(b 2))
            (lcfg-maps:filter-empty '(#m() #m(a 1) #m() #m(b 2) #m()))))

(deftest filter-empty-none
  (is-equal '(#m(a 1) #m(b 2) #m(c 3))
            (lcfg-maps:filter-empty '(#m(a 1) #m(b 2) #m(c 3)))))

(deftest merge-nested-flat
  (let ((m1 #m(a 1 b 2 c 3 e 6))
        (m2 #m(b 3 c 4 d 5)))
    (is-equal #m(a 1 b 3 c 4 d 5 e 6)
              (lcfg-maps:merge-nested m1 m2))
    (is-equal #m(a 1 b 3 c 4 d 5 e 6)
              (lcfg-maps:merge-nested (list m1 m2)))))

(deftest merge-nested-deep
  (let ((m1 #m(a 1
               b #m(c 2 d 3 e #m(f 4 g #m(h 5 i 6)))
               j 7
               z 99
               k #m(l #m(m #m(n #m(o #m(p #m(q 8 r 9))))))))  
        (m2 #m(a 1
               b #m(c 30 d 3 e #m(f 4 g #m(h 10 i 10)))
               x 40
               j 70
               k #m(l #m(m #m(n #m(o #m(p #m(q 8 r 20)))))))))
    (is-equal #m(a 1
                 b #m(c 30 d 3 e #m(f 4 g #m(h 10 i 10)))
                 j 70
                 k #m(l #m(m #m(n #m(o #m(p #m(q 8 r 20))))))
                 x 40
                 z 99)
              (lcfg-maps:merge-nested m1 m2))
    (is-equal #m(a 1
                 b #m(c 30 d 3 e #m(f 4 g #m(h 10 i 10)))
                 j 70
                 k #m(l #m(m #m(n #m(o #m(p #m(q 8 r 20))))))
                 x 40
                 z 99)
              (lcfg-maps:merge-nested (list m1 m2)))))
