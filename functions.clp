;;; Declaracion de clases propias ----------------------

(deftemplate MAIN::Usuario
	(slot minimo (type INTEGER))
	(slot maximo (type INTEGER))
    (slot nombre (type STRING))
	(slot sexo (type SYMBOL) (default desconocido))
	(slot edad (type INTEGER) (default -1))
	(slot familia (type SYMBOL) (default desconocido))
)
;;; Fin de declaracion de clases propias --------------


;;; Declaracion de modulos ----------------------------

;;; Modulo principal de utilidades, indicamos que exportamos todo
(defmodule MAIN (export ?ALL))

;;; Modulo de recopilacion de los datos de la persona
(defmodule recopilacion-persona
	(import MAIN ?ALL)
	(export ?ALL)
)
;;; Fin declaracion de modulos ------------------------


;;; Declaracion de funciones --------------------------

;;; Funcion para hacer una pregunta con respuesta cualquiera
(deffunction pregunta-general (?pregunta)
    (format t "%s " ?pregunta)
	(bind ?respuesta (read))
	(while (not (lexemep ?respuesta)) do
		(format t "%s " ?pregunta)
		(bind ?respuesta (read))
    )
	?respuesta
)

;;; Funcion para hacer una pregunta con respuesta numerica unica
(deffunction MAIN::pregunta-numerica (?pregunta ?rangini ?rangfi)
	(format t "%s [%d, %d] " ?pregunta ?rangini ?rangfi)
	(bind ?respuesta (read))
	(while (not(and(>= ?respuesta ?rangini)(<= ?respuesta ?rangfi))) do
		(format t "%s [%d, %d] " ?pregunta ?rangini ?rangfi)
		(bind ?respuesta (read))
	)
	?respuesta
)
