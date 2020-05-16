;;; Modulo principal de utilidades, indicamos que exportamos todo
(defmodule MAIN (export ?ALL))

;;; Modulo de recopilacion de los datos del usuario
(defmodule recopilacion-persona
	(import MAIN ?ALL)
	(export ?ALL)
)
;;; Declaracion de reglas y hechos ---------------------

(defrule MAIN::initialRule "Regla inicial"
	(declare (salience 10))
	=>
	(printout t "====================================================================" crlf)
  	(printout t "=         Sistema de recomendacion de programas de entrenamiento de Coaching Potato          =" crlf)
	(printout t "====================================================================" crlf)
  	(printout t crlf)  	
	(printout t "¡Bienvenido al sistema de Coaching Potato! A continuación se le formularán una serie de preguntas para poder recomendarle contenidos." crlf)
	(printout t crlf)
	(focus recopilacion-persona)
)

(deftemplate MAIN::entrada
    (slot peso (type INTEGER))
)

(deffacts MAIN::init
    (entrada)
)


;;; Modulo recopilacion

(defrule recopilacion-persona::peso
  (not (got-peso))
  ?user <- (entrada)
  =>
    (bind ?num (pregunta-numerica "Peso (kg)" 1 400))
    (modify ?user (peso ?num))
    (assert (got-peso))
)
