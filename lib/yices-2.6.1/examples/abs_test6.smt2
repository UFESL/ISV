(set-logic QF_LIA)
(declare-fun x () Int)
(assert (> (abs x) 0))
(assert (< x 1))
(check-sat)
(get-value (x (abs x)))
