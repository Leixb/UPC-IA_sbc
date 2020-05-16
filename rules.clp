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
	(bind ?peso (pregunta-numerica "¿Cuánto pesas (en kilos)? " 20 300))
	(bind ?altura (pregunta-numerica "¿Cuánto mides (en centimetros)? " 50 300))
    (bind ?alturaMetros (/ ?altura 100.0))
	(bind ?imc (/ ?peso (* ?alturaMetros ?alturaMetros)))
	(bind ?edad (pregunta-numerica "¿Cuantos años tienes? " 14 110))
	(bind ?p_sang_min (pregunta-numerica "¿Que presión sanguínea mínima tienes (en mmHg)? " 60 100))
	(bind ?p_sang_max (pregunta-numerica "¿Que presión sanguínea máxima tienes (en mmHg)? " 100 150))
	
	(make-instance pers of persona (peso ?peso) (altura ?altura) (imc ?imc) (edad ?edad) (presion_sanguinea_min ?p_sang_min) (presion_sanguinea_max ?p_sang_max))
)

(defrule inferencia::skip
    ?p <- (object (is-a persona))
    => 
    (send ?p escribe-persona)
    (printout ?*debug-print* "inferencia -> generar-resultado" crlf)
    (focus generar-resultado)
)

(defrule generar-resultado::skip
    => 
    (printout ?*debug-print* "generar-resultado -> print-resultado" crlf)
    (focus print-resultado)
)

(defrule print-resultado::print-res
    =>
    (printout t "DONE" crlf)
    (exit)
)

(defrule recopilacion-persona::establecer-info-extra "Establece la info extra de la persona"
    ?p <- (object (is-a persona))
    =>
    (bind ?ejercicio (pregunta-si-no "¿Quieres hacer un ejercicio simple para tener una recomendacion que se adapte más a tu estado fisico actual? "))
	(if (eq ?ejercicio TRUE) then
        (assert (extra))
        (printout t crlf "Haz una carrera sostenida durante 1 minuto y responde a las siguientes preguntas." crlf)
        
        (bind ?pulsaciones_por_minuto (pregunta-numerica "Al acabar el ejercicio, ¿que frecuencia cardíaca tienes (en pulsaciones por minuto)? " 50 250))
        (send ?p put-pulsaciones_por_minuto ?pulsaciones_por_minuto)
        
        (bind ?mareo (pregunta-si-no "¿Has tenido sensación de mareo? "))
        (send ?p put-mareo ?mareo)
        
        (bind ?cansancio (pregunta-si-no "¿Has tenido sensación de cansancio? "))
        (send ?p put-cansancio ?cansancio)
        
        (bind ?tirantez_muscular (pregunta-si-no "¿Has tenido sensación de tirantez muscular? "))
        (send ?p put-tirantez_muscular ?tirantez_muscular)
	)
    (focus inferencia)
)
;;;Para comprobar que se ha guardado bien se ha de ejecutar:    (send [pers] escribe-persona)
(defmessage-handler persona escribe-persona()
    (printout t 
        "Peso: " ?self:peso crlf
        "Altura: " ?self:altura crlf
        "Imc: " ?self:imc crlf
        "Edad: " ?self:edad crlf
        "P_sang_min: " ?self:presion_sanguinea_min crlf
        "P_sang_max: " ?self:presion_sanguinea_max crlf
    )
    (printout t
      "Pulsaciones por minuto: " ?self:pulsaciones_por_minuto crlf
      "Mareo: " ?self:mareo crlf
      "Cansancio: " ?self:cansancio crlf
      "Tirantez muscular: " ?self:tirantez_muscular crlf
    )
	(exit)
)

