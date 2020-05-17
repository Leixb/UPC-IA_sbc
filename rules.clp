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
	(bind ?t_disponible (pregunta-numerica "¿Cuanto tiempo disponible tienes a diario (en minutos)? " 30 300))
	
	(make-instance pers of persona (peso ?peso) (altura ?altura) (imc ?imc) (edad ?edad) (presion_sanguinea_min ?p_sang_min) (presion_sanguinea_max ?p_sang_max) (tiempo_disponible ?t_disponible))
)

;;; Recopilacion persona

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
	(assert (objetivos ASK))
)

(defrule recopilacion-persona::establecer-objetivos "Establece los objetivos de la persona"
	?aux <- (objetivos ASK)
	?p <- (object (is-a persona))
	=>
	(bind $?list-objetivos (find-all-instances ((?inst objetivo)) TRUE))
	(bind $?nom-obj (create$ ))
	(loop-for-count (?i 1 (length$ $?list-objetivos)) do
		(bind ?curr-obj (nth$ ?i ?list-objetivos))
		(bind ?curr-nom (send ?curr-obj get-nombre_objetivo))
		(bind $?nom-obj(insert$ $?nom-obj (+ (length$ $?nom-obj) 1) ?curr-nom))
	)
	(bind ?escogido (pregunta-multi "¿Que objetivos quieres alcanzar? " $?nom-obj))
	
	(bind $?respuesta (create$ ))
	(loop-for-count (?i 1 (length$ ?escogido)) do
		(bind ?curr-index (nth$ ?i ?escogido))
		(bind ?curr-resp (nth$ ?curr-index ?list-objetivos))
		(bind $?respuesta(insert$ $?respuesta (+ (length$ $?respuesta) 1) ?curr-resp))
	)
	(send ?p put-quiere $?respuesta)
	
	(retract ?aux)
	(assert (problemas ASK))
)

(defrule recopilacion-persona::establecer-probelmas "Establece los probelmas musculo-esqueleticos de la persona"
	?aux <- (problemas ASK)
	?p <- (object (is-a persona))
	=>
	(bind ?probs (pregunta-si-no "¿Tienes algún problema musculo-esqueletico? "))
	(if (eq ?probs TRUE) then	
        (bind $?list-probelmas (find-all-instances ((?inst probelma_musculo-esqueletico)) TRUE))
        (bind $?nom-prob (create$ ))
        (loop-for-count (?i 1 (length$ $?list-probelmas)) do
            (bind ?curr-prob (nth$ ?i ?list-probelmas))
            (bind ?curr-nom (send ?curr-prob get-nombre_problema))
            (bind $?nom-prob(insert$ $?nom-prob (+ (length$ $?nom-prob) 1) ?curr-nom))
        )
        (bind ?escogido (pregunta-multi "Selecciona uno o más: " $?nom-prob))
        
        (bind $?respuesta (create$ ))
        (loop-for-count (?i 1 (length$ ?escogido)) do
            (bind ?curr-index (nth$ ?i ?escogido))
            (bind ?curr-resp (nth$ ?curr-index ?list-probelmas))
            (bind $?respuesta(insert$ $?respuesta (+ (length$ $?respuesta) 1) ?curr-resp))
        )
        (send ?p put-tiene $?respuesta)
	)
	
	(retract ?aux)
	(assert (dieta ASK))
)

(defrule recopilacion-persona::establecer-dieta "Establece la dieta de la persona"
	?aux <- (dieta ASK)
	?p <- (object (is-a persona))
	=>
	(bind $?list-dietas (find-all-instances ((?inst dieta)) TRUE))
    (bind $?nom-dieta (create$ ))
    (loop-for-count (?i 1 (length$ $?list-dietas)) do
        (bind ?curr-dieta (nth$ ?i ?list-dietas))
        (bind ?curr-nom (send ?curr-dieta get-nombre_dieta))
        (bind $?nom-dieta(insert$ $?nom-dieta (+ (length$ $?nom-dieta) 1) ?curr-nom))
    )
    (bind ?escogido (pregunta-multi "Selecciona una o más de las siguientes opciones relacionadas con tu dieta: " $?nom-dieta))
    
    (bind $?respuesta (create$ ))
    (loop-for-count (?i 1 (length$ ?escogido)) do
        (bind ?curr-index (nth$ ?i ?escogido))
        (bind ?curr-resp (nth$ ?curr-index ?list-dietas))
        (bind $?respuesta(insert$ $?respuesta (+ (length$ $?respuesta) 1) ?curr-resp))
    )
    (send ?p put-sigue_una $?respuesta)
	
	(retract ?aux)
	(assert (habitos ASK))
)

(defrule recopilacion-persona::establecer-habitos "Establece los habitos de la persona"
	?aux <- (habitos ASK)
	?p <- (object (is-a persona))
	=>
    (bind $?nom-hab (slot-allowed-values habito_personal tipo_habito))
    (bind ?escogido (pregunta-multi "¿Haces alguno de los siguientes hábitos personales? " $?nom-hab))
    
    (bind $?respuesta (create$ ))
    (loop-for-count (?i 1 (length$ ?escogido)) do
        (bind ?curr-index (nth$ ?i ?escogido))
        (bind ?curr-resp (nth$ ?curr-index ?nom-hab))
        (printout t ?curr-resp ":" crlf)
        
        (bind ?frecuencia (pregunta-numerica "   ¿Cuantas veces a la semana realizas esta actividad? " 1 30))
        (bind ?duracion (pregunta-numerica "   ¿Cuanto tiempo le dedicas cada vez (en minutos)? " 1 180))
        
        (make-instance of habito_personal (tipo_habito ?curr-resp) (frecuencia ?frecuencia) (duracion_habito ?duracion))
    
        (bind ?curr-index (nth$ ?i ?escogido))
        (bind ?curr-resp (nth$ ?curr-index ?nom-hab))
        (bind $?respuesta(insert$ $?respuesta (+ (length$ $?respuesta) 1) ?curr-resp))
    )
    (send ?p put-hace $?respuesta)
	
	(retract ?aux)
	(focus inferencia)
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
    ;(exit)
)

;;; Muestra ejercicio
(deffunction MAIN::separador ()
    (printout t "================================================================================" crlf)
)

(deffunction MAIN::separador_corto ()
    (printout t "----------------------------------------" crlf)
)

(deffunction MAIN::print-ejercicios-dia (?dia ?ejercicios)
    (separador)
    (printout t "= " ?dia crlf)
    (foreach ?ej ?ejercicios
        (separador_corto)
        (send (instance-address ?ej) imprimir)
    )
)

(defmessage-handler programa_de_entrenamiento imprimir()
    (print-ejercicios-dia "Lunes" ?self:ej_lunes)
    (print-ejercicios-dia "Martes" ?self:ej_martes)
    (print-ejercicios-dia "Miercoles" ?self:ej_miercoles)
    (print-ejercicios-dia "Jueves" ?self:ej_jueves)
    (print-ejercicios-dia "Viernes" ?self:ej_viernes)
    (print-ejercicios-dia "Sabado" ?self:ej_sabado)
    (print-ejercicios-dia "Domingo" ?self:ej_domingo)
)

(defmessage-handler ejercicio_con_repeticiones imprimir()
    (bind ?nombre_ej (send ?self:ejercicio_a_repetir get-nombre_ejercicio))
    (printout t
        "Ejercicio: " ?nombre_ej crlf
        "Repeticiones: " ?self:repeticiones crlf
        "Dificultad: " ?self:dificultad_ejercicio crlf
    )
    (send ?self:ejercicio_a_repetir imprimir)
)

(defmessage-handler ejercicio imprimir()
    (printout t
        "Calorias: " ?self:calorias crlf
        "Duracion: de " ?self:duracion_min " a " ?self:duracion_max " minutos." crlf
    )
    (printout t "Combina con: ")
    (loop-for-count (?i 1 (length$ ?self:combina_con)) do
        (printout t (send (nth$ ?i ?self:combina_con) get-nombre_ejercicio) ", ")
    )
    (printout t crlf)
;dificultad
;ejercicio_cubre_un
;nombre_ejercicio
;repeticiones_max
;repeticiones_min
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
        "Tiempo disponible: " ?self:tiempo_disponible crlf
    )
    (printout t
      "Pulsaciones por minuto: " ?self:pulsaciones_por_minuto crlf
      "Mareo: " ?self:mareo crlf
      "Cansancio: " ?self:cansancio crlf
      "Tirantez muscular: " ?self:tirantez_muscular crlf
    )
    (printout t
      "Objetivos: " $?self:quiere crlf
      "Problemas: " $?self:tiene crlf
      "Dietas: " $?self:sigue_una crlf
    )
)

