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

;;; Modulo recopilacion

(defrule recopilacion-persona::establecer-peso "Establece el peso de la persona"
	?p <- (Persona (peso ?peso))
	(test (< ?peso 0))
	=>
	(bind ?peso (pregunta-numerica "¿Cuánto pesas (en kilos)? " 1 300))
	(modify ?p (peso ?peso))
)

(defrule recopilacion-persona::establecer-altura "Establece la altura de la persona"
	?p <- (Persona (altura ?altura))
	(test (< ?altura 0))
	=>
	(bind ?altura (pregunta-numerica "¿Cuánto mides (en metros)? " 0.5 2.50))
	(modify ?p (altura ?altura))
)

(defrule recopilacion-persona::establecer-imc"Establece el imc de la persona"
    ?p <- (Persona (altura ?altura) (peso ?peso) (imc ?imc))
    (test (> ?peso 0))
    (test (> ?altura 0))
    (test (< ?imc 0))
	=>
	(bind ?imc (/ ?peso (* ?altura ?altura)))
	(modify ?p (imc ?imc))
)

(defrule recopilacion-persona::establecer-edad "Establece la edad de la persona"
	?p <- (Persona (edad ?edad))
	(test (< ?edad 0))
	=>
	(bind ?e (pregunta-numerica "¿Cuantos años tienes? " 1 110))
	(modify ?p (edad ?e))
)

(defrule recopilacion-persona::establecer-presion-sanguinea "Establece la presión sanguínea de la persona"
	?p <- (Persona (presion_sanguinea_min ?p_min) (presion_sanguinea_max ?p_max))
	(test (< ?p_min 0))
	(test (< ?p_max 0))
	=>
	(bind ?rango (pregunta-rango "A continuación establece el rango de tu presión sanguínea en mmHg [min, max]: " 60 140))
	(?rango (minimo ?p_min) (maximo ?p_min))
	(modify ?p (presion_sanguinea_min ?p_min) (presion_sanguinea_max ?p_max))
)

(defrule recopilacion-persona::preguntar-si-quiere-info-adicional "Pregunta al usuario si quiere dar información adicional"
	?hecho <- (info-adicional ask)
	=>
	(bind ?respuesta (pregunta-si-no "Quieres hacer una serie de ejercicios para una recomendación que se adapte más a tu estado físico actual? "))
	(retract ?hecho)
	(if (eq ?respuesta TRUE)
		then (assert (info-adicional choose))
		else 
		(assert (info-adicional FALSE))
	)
)
