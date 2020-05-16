;;; Declaracion de reglas y hechos ---------------------

(defrule MAIN::initialRule "Regla inicial"
	(declare (salience 10))
	=>
	(printout t "================================================================================" crlf)
  	(printout t "=  Sistema de recomendacion de programas de entrenamiento de Coaching Potato   =" crlf)
	(printout t "================================================================================" crlf)
  	(printout t crlf)  	
	(printout t "¡Bienvenido al sistema de Coaching Potato! A continuación se le formularán una serie de preguntas para poder recomendarle contenidos." crlf)
	(printout t crlf)
	(focus recopilacion-persona)
)

(defrule recopilacion-persona::establecer-info "Establece la info de la persona"
	(not (persona))
	=>
	(bind ?peso (pregunta-numerica "¿Cuánto pesas (en kilos)? " 1 300))
	(bind ?altura (pregunta-numerica "¿Cuánto mides (en metros)? " 1 3))
	(bind ?imc (/ ?peso (* ?altura ?altura)))
	(bind ?edad (pregunta-numerica "¿Cuantos años tienes? " 14 110))
	(bind ?p_sang_min (pregunta-numerica "¿Que presión sanguínea mínima tienes (en mmHg)? " 60 100))
	(bind ?p_sang_max (pregunta-numerica "¿Que presión sanguínea máxima tienes (en mmHg)? " 100 150))
	
	(make-instance pers of persona (peso ?peso) (altura ?altura) (imc ?imc) (edad ?edad) (presion_sanguinea_min ?p_sang_min) (presion_sanguinea_max ?p_sang_max))
)

(defrule recopilacion-persona::establecer-info-extra "Establece la info extra de la persona"
    ?p <- (object (is-a persona))
    =>
    (bind ?ejercicio (pregunta-si-no "¿Quieres hacer un ejercicio simple para tener una recomendacion que se adapte más a tu estado fisico actual? "))
	(if (eq ?ejercicio TRUE) then
        (assert (extra))
        (printout t crlf "Haz una carrera de 5 minutos y responde a las siguientes preguntas." crlf)
        (bind ?mareo (pregunta-si-no "¿Has tenido sensación de mareo? "))
        (bind ?cansancio (pregunta-si-no "¿Has tenido sensación de cansancio? "))
        
        (send ?p put-mareo ?mareo)
        (send ?p put-cansancio ?cansancio)
	)
)

;;;Para comprobar que se ha guardado bien se ha de ejecutar:    (send [pers] escribe-persona)
(defmessage-handler persona escribe-persona()
    (if (not (extra)) then 
        (printout t "Peso: " ?self:peso crlf "Altura: " ?self:altura crlf "Imc: " ?self:imc crlf "Edad: " ?self:edad crlf "P_sang_min: " ?self:presion_sanguinea_min crlf "P_sang_max: " ?self:presion_sanguinea_max crlf)
    else 
        (printout t "Peso: " ?self:peso crlf "Altura: " ?self:altura crlf "Imc: " ?self:imc crlf "Edad: " ?self:edad crlf "P_sang_min: " ?self:presion_sanguinea_min crlf "P_sang_max: " ?self:presion_sanguinea_max crlf "Mareo: " ?self:mareo crlf "Cansancio: " ?self:cansancio crlf)
    )
    (exit)
)

