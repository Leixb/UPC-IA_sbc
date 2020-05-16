(deffunction MAIN::is-num (?num)
  (or (eq (type ?num) INTEGER) (eq (type ?num) FLOAT))
)

(deffunction MAIN::num-between (?num ?min ?max)
  (and (is-num ?num) (>= ?num ?min) (<= ?num ?max))
)

(deffunction MAIN::pregunta-numerica (?question ?min ?max)
  (while TRUE do ;return function will exit this loop
    (printout t " -> " ?question ": ")
    (bind ?answer (read))
    (if (num-between ?answer ?min ?max) then
      (return ?answer)
	  else 
      (format t " ! Error: Entrada invalida! rango: %d, %d" ?min ?max)
      (printout t crlf)
    )
  )
)
