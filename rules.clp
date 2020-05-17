;;; Declaracion de reglas y hechos ---------------------

(defrule MAIN::initialRule "Regla inicial"
	(declare (salience 10))
	=>
	(printout t "╔═════════════════════════════════════════════════════════════════════════════╗" crlf)
  	(printout t "║  Sistema de recomendacion de programas de entrenamiento de Coaching Potato  ║" crlf)
	(printout t "╚═════════════════════════════════════════════════════════════════════════════╝" crlf)
  	(printout t crlf)  	
	(printout t "¡Bienvenido al sistema de Coaching Potato!" crlf)
	(printout t "A continuación se te harán una serie de preguntas para poder recomendarte el" crlf)
	(printout t "programa de entrenamiento que se adapte más a ti." crlf)
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

(deftemplate recopilacion-persona::extra)

(defrule recopilacion-persona::establecer-info-extra "Establece la info extra de la persona"
    ?p <- (object (is-a persona))
    =>
    (bind ?ejercicio (pregunta-si-no "¿Quieres hacer un ejercicio simple para tener una recomendacion que se adapte
más a tu estado fisico actual? "))
	(if (eq ?ejercicio TRUE) then
        (assert (extra))
        (printout t crlf "Haz una carrera sostenida durante 1 minuto." crlf)
        
        (bind ?pulsaciones_por_minuto (pregunta-numerica "Al acabar el ejercicio, ¿que frecuencia cardíaca tienes (en ppm)? " 50 250))
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
    (foreach ?curr-obj ?list-objetivos
		(bind ?curr-nom (send ?curr-obj get-nombre_objetivo))
		(bind $?nom-obj(insert$ $?nom-obj (+ (length$ $?nom-obj) 1) ?curr-nom))
	)
	(bind ?escogido (pregunta-multi "¿Que objetivos quieres alcanzar? " $?nom-obj))
	
	(bind $?respuesta (create$ ))
    (foreach ?curr-index ?escogido
		(bind ?curr-resp (nth$ ?curr-index ?list-objetivos))
		(bind $?respuesta(insert$ $?respuesta (+ (length$ $?respuesta) 1) ?curr-resp))
	)
	(send ?p put-quiere $?respuesta)
	
	(retract ?aux)
	(assert (problemas ASK))
)

(defrule recopilacion-persona::establecer-problemas "Establece los problemas musculo-esqueleticos de la persona"
	?aux <- (problemas ASK)
	?p <- (object (is-a persona))
	=>
	(bind ?probs (pregunta-si-no "¿Tienes algún problema musculo-esqueletico? "))
	(if (eq ?probs TRUE) then	
        (bind $?list-problemas (find-all-instances ((?inst probelma_musculo-esqueletico)) TRUE))
        (bind $?nom-prob (create$ ))
        (foreach ?curr-prob ?list-problemas
            (bind ?curr-nom (send ?curr-prob get-nombre_problema))
            (bind $?nom-prob(insert$ $?nom-prob (+ (length$ $?nom-prob) 1) ?curr-nom))
        )
        (bind ?escogido (pregunta-multi "Selecciona uno o más: " $?nom-prob))
        
        (bind $?respuesta (create$ ))
        (foreach ?curr-index ?escogido
            (bind ?curr-resp (nth$ ?curr-index ?list-problemas))
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
    (foreach ?curr-dieta ?list-dietas
        (bind ?curr-nom (send ?curr-dieta get-nombre_dieta))
        (bind $?nom-dieta(insert$ $?nom-dieta (+ (length$ $?nom-dieta) 1) ?curr-nom))
    )
    (bind ?escogido (pregunta-multi "Selecciona una o más de las siguientes opciones relacionadas con tu dieta: " $?nom-dieta))
    
    (bind $?respuesta (create$ ))
    (foreach ?curr-index ?escogido
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
    (foreach ?curr-index ?escogido
        (bind ?curr-resp (nth$ ?curr-index ?nom-hab))
        (printout t ?curr-resp ":" crlf)
        
        (bind ?frecuencia (pregunta-numerica "   ¿Cuantas veces a la semana realizas esta actividad? " 1 30))
        (bind ?duracion (pregunta-numerica "   ¿Cuanto tiempo le dedicas cada vez (en minutos)? " 1 180))
        
        (make-instance of habito_personal (tipo_habito ?curr-resp) (frecuencia ?frecuencia) (duracion_habito ?duracion))
    
        (bind $?respuesta(insert$ $?respuesta (+ (length$ $?respuesta) 1) ?curr-resp))
    )
    (send ?p put-hace $?respuesta)
	
	(retract ?aux)
	(focus inferencia)
)

(deftemplate inferencia::condiciones_fisicas
    (slot imc
        (type SYMBOL)
        (allowed-values peso_bajo peso_normal sobrepeso obesidad)
    )
    (slot edad
        (type SYMBOL)
        (allowed-values joven adulto-joven adulto-medio adulto-mayor)
    )
    (slot dieta
        (type SYMBOL)
        (allowed-values buena correcta mala)
    )
    (slot presion_sanguinea
        (type SYMBOL)
        (allowed-values baja media alta)
    )
    (slot estamina
        (type SYMBOL)
        (default desconocida)
        (allowed-values desconocida muy_baja baja media alta)
    )
)

(defrule inferencia::init
    =>
    (assert (condiciones_fisicas))
)

(defrule inferencia::next
    (IMC_done)
    (EDAD_done)
    (ESTAMINA_done)
    (PRESSION_done)
    (DIETA_done)
    ?p <- (object (is-a persona))
    => 

    (if ?*debug* then
        (send ?p escribe-persona)
        (facts)
    )
    (printout ?*debug-print* "inferencia -> generar-resultado" crlf)

    (focus generar-resultado)
)

(defrule inferencia::imc
    (not (IMC_done))
    ?p <- (object (is-a persona) (imc ?imc))
    ?c <- (condiciones_fisicas)
    =>
    (printout ?*debug-print* "Inferencia de IMC: " ?imc crlf)

    (     if (< ?imc 18.5 ) then (modify ?c (imc peso_bajo))
    else (if (< ?imc 25   ) then (modify ?c (imc peso_normal))
    else (if (< ?imc 30   ) then (modify ?c (imc sobrepeso))
    else                         (modify ?c (imc obesidad))
    )))

    (assert (IMC_done))
)

(defrule inferencia::edad
    (not (EDAD_done))
    ?p <- (object (is-a persona) (edad ?edad))
    ?c <- (condiciones_fisicas)
    =>
    (printout ?*debug-print* "Inferencia de edad: " ?edad crlf)

    (     if (< ?edad 30   ) then (modify ?c (edad joven))
    else (if (< ?edad 45   ) then (modify ?c (edad adulto-joven))
    else (if (< ?edad 60   ) then (modify ?c (edad adulto-medio))
    else                          (modify ?c (edad adulto-mayor))
    )))

    (assert (EDAD_done))
)

(defrule inferencia::estamina
    (not (ESTAMINA_done))
    ?p <- (object (is-a persona)
        (pulsaciones_por_minuto ?pulsaciones)
        (mareo ?mareo)
        (cansancio ?cansancio)
        (tirantez_muscular ?tirantez)
    )
    ?c <- (condiciones_fisicas)
    =>
    (printout ?*debug-print* "Inferencia de estamina: "
        ?pulsaciones ?mareo ?cansancio ?tirantez crlf)
    (if (neq ?pulsaciones -1) then ; si no tenemos info, dejamos el default (desconocido)
        (if (or ?mareo ?tirantez)     then (modify ?c (estamina muy_baja))
        else (if ?cansancio           then (modify ?c (estamina baja))
        else (if (> ?pulsaciones 120) then (modify ?c (estamina baja))
        else (if (> ?pulsaciones 90)  then (modify ?c (estamina media))
        else                               (modify ?c (estamina alta))
        ))))
    )

    (assert (ESTAMINA_done))
)

; TODO
(defrule inferencia::dieta
    (not (DIETA_done))
    ?c <- (condiciones_fisicas)
    =>
    (assert (DIETA_done))
)

; TODO
(defrule inferencia::pression_sanguinea
    (not (PRESSION_done))
    (EDAD_done)
    ?c <- (condiciones_fisicas (edad ?edad))
    =>
    (assert (PRESSION_done))
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
    (printout t "╞═══════════════════════════════════════════════════════════════════════════════" crlf)
)

(deffunction MAIN::separador_corto ()
    (printout t "├───────────────────────────────────────" crlf)
)

(deffunction MAIN::print-ejercicios-dia (?dia ?ejercicios)
    (separador)
    (printout t "╞ " ?dia crlf)
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
        "│ Ejercicio: " ?nombre_ej crlf
        "│ Repeticiones: " ?self:repeticiones crlf
        "│ Dificultad: " ?self:dificultad_ejercicio crlf
    )
    (send ?self:ejercicio_a_repetir imprimir)
)

(defmessage-handler ejercicio imprimir()
    (printout t
        "│ Calorias: " ?self:calorias crlf
        "│ Duracion: de " ?self:duracion_min " a " ?self:duracion_max " minutos." crlf
    )
    (printout t "│ Combina con: ")
    (foreach ?ej ?self:combina_con
        (printout t (send ?ej get-nombre_ejercicio) ", ")
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
      "Habitos: " $?self:hace crlf
    )
)

