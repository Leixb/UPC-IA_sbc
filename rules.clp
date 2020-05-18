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
	(focus entrada)
)

(defrule entrada::establecer-info "Establece la info de la persona"
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

(deftemplate entrada::extra)

(defrule entrada::establecer-info-extra "Establece la info extra de la persona"
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

(defrule entrada::establecer-objetivos "Establece los objetivos de la persona"
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

(defrule entrada::establecer-problemas "Establece los problemas musculo-esqueleticos de la persona"
	?aux <- (problemas ASK)
	?p <- (object (is-a persona))
	=>
	(bind ?probs (pregunta-si-no "¿Tienes algún problema musculo-esqueletico? "))
	(if (eq ?probs TRUE) then
        (bind $?list-problemas (find-all-instances ((?inst problema_musculo-esqueletico)) TRUE))
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

(defrule entrada::establecer-dieta "Establece la dieta de la persona"
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

(defrule entrada::establecer-habitos "Establece los habitos de la persona"
	?aux <- (habitos ASK)
	?p <- (object (is-a persona))
	=>
    (bind $?list-habitos (find-all-instances ((?inst habito_personal)) TRUE))
    (bind $?nom-hab (create$ ))
    (foreach ?curr-hab ?list-habitos
        (bind ?curr-nom (send ?curr-hab get-nombre_habito))
        (bind $?nom-hab(insert$ $?nom-hab (+ (length$ $?nom-hab) 1) ?curr-nom))
    )
    (bind ?escogido (pregunta-multi "¿Sigues alguno de los siguientes hábitos personales? " $?nom-hab))

    (bind $?respuesta (create$ ))
    (foreach ?curr-index ?escogido
        (bind ?curr-resp (nth$ ?curr-index ?list-habitos))

        (bind ?curr-resp-nom (send ?curr-resp get-nombre_habito))
        (printout t ?curr-resp-nom ":" crlf)

        (bind ?frecuencia (pregunta-numerica "   ¿Cuantas veces a la semana realizas esta actividad? " 1 30))
        (bind ?duracion (pregunta-numerica "   ¿Cuanto tiempo le dedicas cada vez (en minutos)? " 1 180))

        (send ?curr-resp put-frecuencia ?frecuencia)
        (send ?curr-resp put-duracion_habito ?duracion)

        (bind $?respuesta(insert$ $?respuesta (+ (length$ $?respuesta) 1) ?curr-resp))
    )
    (send ?p put-hace $?respuesta)

	(retract ?aux)
	(focus abstraccion)
)

(deftemplate abstraccion::condiciones_fisicas
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
        (allowed-values baja media alta inestable)
    )
    (slot estamina
        (type SYMBOL)
        (default desconocida)
        (allowed-values desconocida muy_baja baja media alta)
    )
)

(deftemplate abstraccion::objetivos_usuario
    (multislot lista-objetivos
        (type INSTANCE)
        (allowed-classes objetivo)
    )
)

(defrule abstraccion::init
    =>
    (assert (condiciones_fisicas))
    (assert (objetivos_usuario))
    (assert (habitos_personales))
)

(defrule abstraccion::next
    (IMC_done)
    (EDAD_done)
    (ESTAMINA_done)
    (PRESSION_done)
    (DIETA_done)
    (HABITOS_done)
    (OBJETIVOS_done)
    ?p <- (object (is-a persona))
    =>

    (if ?*debug* then
        (send ?p imprimir)
        (facts)
    )
    (printout ?*debug-print* "abstraccion -> associacion" crlf)

    (focus associacion)
)

(defrule abstraccion::imc
    (not (IMC_done))
    (object (is-a persona) (imc ?imc))
    ?c <- (condiciones_fisicas)
    =>
    (printout ?*debug-print* "abstraccion de IMC: " ?imc crlf)

    (     if (< ?imc 18.5 ) then (modify ?c (imc peso_bajo))
    else (if (< ?imc 25   ) then (modify ?c (imc peso_normal))
    else (if (< ?imc 30   ) then (modify ?c (imc sobrepeso))
    else                         (modify ?c (imc obesidad))
    )))

    (assert (IMC_done))
)

(defrule abstraccion::edad
    (not (EDAD_done))
    (object (is-a persona) (edad ?edad))
    ?c <- (condiciones_fisicas)
    =>
    (printout ?*debug-print* "abstraccion de edad: " ?edad crlf)

    (     if (< ?edad 30   ) then (modify ?c (edad joven))
    else (if (< ?edad 45   ) then (modify ?c (edad adulto-joven))
    else (if (< ?edad 60   ) then (modify ?c (edad adulto-medio))
    else                          (modify ?c (edad adulto-mayor))
    )))

    (assert (EDAD_done))
)

(defrule abstraccion::estamina
    (not (ESTAMINA_done))
    (object (is-a persona)
        (pulsaciones_por_minuto ?pulsaciones)
        (mareo ?mareo)
        (cansancio ?cansancio)
        (tirantez_muscular ?tirantez)
    )
    ?c <- (condiciones_fisicas)
    =>
    (printout ?*debug-print* "abstraccion de estamina: "
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

(defrule abstraccion::dieta
    (not (DIETA_done))
    ?c <- (condiciones_fisicas)
    (object (is-a persona) (sigue_una $?dieta))
    =>
    (bind ?suma 0)
    (foreach ?elemento ?dieta
        (bind ?suma (+ ?suma (send ?elemento get-saludable)))
    )
    (printout ?*debug-print* "Valor dieta: " ?suma crlf)
    (if (< ?suma -5) then (modify ?c (dieta mala))
    else (if (> ?suma 5) then (modify ?c (dieta buena))
    else (modify ?c (dieta correcta)))
    )
    (assert (DIETA_done))
)

(defrule abstraccion::presion_sanguinea
    (not (PRESSION_done))
    (EDAD_done)
    (object (is-a persona)
        (presion_sanguinea_min ?p_min)
        (presion_sanguinea_max ?p_max)
    )
    ?c <- (condiciones_fisicas (edad ?edad))
    =>
    (printout ?*debug-print* "abstraccion de presion sanguínea: "
        ?edad ?p_min ?p_max crlf)

    (bind ?diff (- ?p_max ?p_min))
    (if (> ?diff 70)            then (modify ?c (presion_sanguinea inestable))
    else
        (switch ?edad
            (case joven then (bind ?aux1 90) (bind ?aux2 140))
            (case adulto-joven then (progn (bind ?aux1 80) (bind ?aux2 130)))
            (case adulto-medio then (progn (bind ?aux1 70) (bind ?aux2 120)))
            (case adulto-mayor then (progn (bind ?aux1 60) (bind ?aux2 110)))
            (default none)
        )
        (bind ?p_mean (/ (+ ?p_min ?p_max) 2))

        (if (< ?p_mean ?aux1) then (modify ?c (presion_sanguinea baja))
        else (if (< ?p_mean ?aux2) then (modify ?c (presion_sanguinea media))
        else (modify ?c (presion_sanguinea alta))
    )))
    (assert (PRESSION_done))
)

(defrule abstraccion::habitos_alcanzan
    (not (HABITOS_done))
    (OBJETIVOS_done)
    (object (is-a persona) (hace $?habitos))
    =>
    (foreach ?habito $?habitos
        (send ?habito computa-alcanzado)
    )
    (if ?*debug* then
        (bind $?list-obj (find-all-instances ((?inst objetivo)) TRUE))
        (foreach ?hab ?list-obj
            (bind ?nom (send ?hab get-nombre_objetivo))
            (bind ?alcan (send ?hab get-alcanzado))
            (printout t ?nom " -> " ?alcan crlf)
        )
    )
    (assert (HABITOS_done))
)

(defrule abstraccion::copia_objetivos
    (not (OBJETIVOS_done))
    (object (is-a persona) (quiere $?objetivos))
    ?o <- (objetivos_usuario)
    =>
    (printout ?*debug-print* "lista: " $?objetivos crlf)
    (modify ?o (lista-objetivos $?objetivos))
    (assert (OBJETIVOS_done))
)

(deftemplate associacion::condicion_fisica
    (slot salud
			(type SYMBOL)
			(allowed-values mala normal buena)
    )
    (slot forma_fisica
			(type SYMBOL)
			(allowed-values muy_mala mala buena muy_buena)
    )
)

(defrule associacion::condicion_fisica
	(not (CONDICION_FISICA_done))
	?c <- (condiciones_fisicas (imc ?imc) (edad ?edad) (dieta ?dieta) (presion_sanguinea ?p_sang) (estamina ?estamina))
	=>
	(if (or (or (eq ?imc obesidad) (eq ?p_sang inestable)) (eq ?dieta mala))
		then (bind ?salud mala)
	else (if (or (or (or (eq ?imc sobrepeso) (eq ?imc peso_bajo)) (or (eq ?p_sang baja) (eq ?p_sang alta))) (eq ?dieta correcta))
		then (bind ?salud normal)
	else (bind ?salud buena)
	))

	(if (or (eq ?imc obesidad) (eq ?estamina muy_baja))
		then (bind ?forma_fisica muy_mala)
	else (if (or (or (eq ?imc sobrepeso) (eq ?imc peso_bajo)) (or (eq ?estamina baja) (eq ?edad adulto-mayor)))
		then (bind ?forma_fisica mala)
	else (if (or (eq ?edad adulto-medio) (eq ?estamina media))
		then (bind ?forma_fisica buena)
	else (bind ?forma_fisica muy_buena)
	)))

	(assert (condicion_fisica (salud ?salud) (forma_fisica ?forma_fisica)))
	(assert (CONDICION_FISICA_done))
)

(deffunction associacion::muestra_ej_puntuacion ()
    (do-for-all-instances ((?ejercicio ejercicio)) TRUE
        (bind ?name (send ?ejercicio get-nombre_ejercicio))
        (bind ?punt (send ?ejercicio get-puntuacion))
        (printout t ?name " -> " ?punt crlf)
    )
)

(deffunction associacion::get-max-objetivo-alcanzado()
    (bind ?max -1.0)
    (do-for-all-instances ((?obj objetivo)) TRUE
        (bind ?alcan (send ?obj get-alcanzado))
        (bind ?max (max ?max ?alcan))
    )
    ?max
)

(defrule associacion::puntua-ej-objetivos
    (objetivos_usuario (lista-objetivos $?objetivos))
    =>
    (bind ?max (get-max-objetivo-alcanzado))
    (foreach ?objetivo ?objetivos
        (bind ?puntuacion (/ (send ?objetivo get-alcanzado) ?max))
        (do-for-all-instances ((?ejercicio ejercicio))
                (send ?ejercicio cubre ?objetivo)
            (printout ?*debug-print* ?ejercicio " cubre objetivo " ?objetivo crlf)
            (send ?ejercicio modifica-puntuacion (- 2 ?puntuacion))

        )
    )
    (if ?*debug* then (muestra_ej_puntuacion))
)

(defmessage-handler ejercicio cubre (?objetivo)
    (bind ?nombre-objetivo (send ?objetivo get-nombre_objetivo))
    (foreach ?obj ?self:ejercicio_cubre_un
        (if (eq ?nombre-objetivo (send ?obj get-nombre_objetivo)) then
            (return TRUE)
        )
    )
    FALSE
)

(defrule associacion::next
	(declare (salience -10))
    =>
    (printout ?*debug-print* "associacion -> refinamiento" crlf)
    (focus refinamiento)
)

(defrule refinamiento::init
    =>
    (assert (programa_de_entrenamiento))
)

(defrule refinamiento::descarta-problemas
    (not (no-aptos-marcados))
    (object (is-a persona) (tiene $?problemas))
    =>
    (foreach ?problema ?problemas
        (send ?problema marca-no-aptos)
    )
    (assert (no-aptos-marcados))
)

(defrule refinamiento::seleccion-ejercicios
    (no-aptos-marcados)
    (object (is-a persona) (tiempo_disponible ?tiempo-diario))
    ?programa <- (programa_de_entrenamiento)
    (condicion_fisica (salud ?salud) (forma_fisica ?forma_fisica))
    =>
    ; 7 dias
    (loop-for-count (?cnt 1 7) do
        (printout ?*debug-print* "Dia " ?cnt crlf)
        (bind ?tiempo ?tiempo-diario)
        (bind ?continue TRUE)
        (while (and (> ?tiempo 0) ?continue)
            (bind ?max -1)
            (bind ?ej-sel nil)
            (bind ?continue (do-for-all-instances ((?ejercicio ejercicio))
                    (and (< ?ejercicio:duracion_min ?tiempo) ?ejercicio:apto)
                (bind ?punt (send ?ejercicio get-puntuacion))
                (if (> ?punt ?max) then
                    (bind ?max ?punt)
                    (bind ?ej-sel ?ejercicio)
                )
                TRUE
            ))

            (if (eq nil ?ej-sel) then
                (printout ?*debug-print* "No ejercicios encontrados" crlf)
                (break)
            )

            (bind ?min_rep (send ?ej-sel get-repeticiones_min))
            (bind ?max_rep (send ?ej-sel get-repeticiones_max))
            (bind ?diff_rep (- ?max_rep ?min_rep))
            (switch ?forma_fisica
                (case muy_mala	then (bind ?repeticiones ?min_rep))
                (case mala			then (bind ?repeticiones (+ ?min_rep (/ ?diff_rep 3))))
                (case buena			then (bind ?repeticiones (+ ?min_rep (* (/ ?diff_rep 3) 2))))
                (case muy_buena	then (bind ?repeticiones ?max_rep))
                (default none)
            )

            (bind ?dificultad_base (send ?ej-sel get-dificultad))
            (switch ?salud
                (case mala		then (bind ?n_dificultad (+ ?dificultad_base 2)))
                (case normal	then (bind ?n_dificultad (+ ?dificultad_base 1)))
                (case buena		then (bind ?n_dificultad ?dificultad_base))
                (default none)
            )
						(if (< ?n_dificultad 5) 			then 	(bind ?dificultad moderada)
						else (if (< ?n_dificultad 8) 	then 	(bind ?dificultad normal)
						else 																(bind ?dificultad dificil)))

            (bind ?duracion (min (* ?repeticiones (send ?ej-sel get-duracion_max)) ?tiempo))
            (bind ?tiempo (- ?tiempo ?duracion))

            (send ?ej-sel multiplica 0.75)
	        (bind ?instancia (make-instance of ejercicio_con_repeticiones
                (ejercicio_a_repetir ?ej-sel)
                (repeticiones ?repeticiones)
                (dificultad_ejercicio ?dificultad)))
                (if ?*debug* then
                    (printout t "----------------------------" crlf)
                    (send ?instancia imprimir)
                )
        )
    )
)

(defrule refinamiento::next
    =>
    (printout ?*debug-print* "refinamiento -> salida" crlf)
    (focus salida)
)

(defrule salida::end
    =>
    (printout t "DONE" crlf)
    (if (not ?*debug*) then (exit))
)

(defmessage-handler problema_musculo-esqueletico marca-no-aptos()
    (foreach ?ejercicio ?self:impide
        (send ?ejercicio put-apto FALSE)
    )
)

(defmessage-handler habito_personal computa-alcanzado ()
    (bind ?alcanza (* ?self:frecuencia ?self:duracion_habito))
    (foreach ?objetivo ?self:habito_cubre_un
        (printout ?*debug-print* "MODIFICANDO " ?objetivo crlf)
        (bind ?alcanzado (send ?objetivo get-alcanzado))
        (send ?objetivo put-alcanzado (+ ?alcanzado ?alcanza))
    )
)

(defmessage-handler objetivo modifica-alcanzado (?alcanza)
    (bind ?self:alcanzado (+ ?self:alcanzado ?alcanza))
)

(defmessage-handler ejercicio modifica-puntuacion (?puntos)
    (bind ?self:puntuacion (+ ?self:puntuacion ?puntos))
    (bind ?puntos-combinacion (/ ?puntos 4))
    (foreach ?ejercicio ?self:combina_con
        (bind ?puntuacion (+ ?puntos-combinacion (send ?ejercicio get-puntuacion)))
        (send ?ejercicio put-puntuacion ?puntuacion)
    )
)

(defmessage-handler ejercicio multiplica (?puntos)
    (bind ?self:puntuacion (* ?self:puntuacion ?puntos))
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
    (printout t crlf "│ Categorias: ")
    (foreach ?obj ?self:ejercicio_cubre_un (printout t (send ?obj get-nombre_objetivo) ", "))
    (printout t crlf)
)

;;;Para comprobar que se ha guardado bien se ha de ejecutar:    (send [pers] imprimir)
(defmessage-handler persona imprimir()
    (separador)
    (printout t "│ Informacion entrada usuario" crlf)
    (separador)
    (printout t
      "│ Peso: " ?self:peso crlf
      "│ Altura: " ?self:altura crlf
      "│ IMC: " ?self:imc crlf
      "│ Edad: " ?self:edad crlf
      "│ Presión sanguínea: " ?self:presion_sanguinea_min "-" ?self:presion_sanguinea_min crlf
      "│ Tiempo disponible: " ?self:tiempo_disponible crlf
    )
    (separador_corto)
    (printout t
      "│ Pulsaciones por minuto: " ?self:pulsaciones_por_minuto crlf
      "│ Mareo: " ?self:mareo crlf
      "│ Cansancio: " ?self:cansancio crlf
      "│ Tirantez muscular: " ?self:tirantez_muscular crlf
    )
    (separador_corto)
    (printout t "│ Objetivos: ")
    (foreach ?obj ?self:quiere (printout t (send ?obj get-nombre_objetivo) ", "))
    (printout t crlf "│ Problemas: ")
    (foreach ?prob ?self:tiene (printout t (send ?prob get-nombre_problema) ", "))
    (printout t crlf "│ Dietas: ")
    (foreach ?dieta ?self:sigue_una (printout t (send ?dieta get-nombre_dieta) ", "))
    (printout t crlf "│ Habitos: ")
    (foreach ?hab ?self:hace (printout t (send ?hab get-nombre_habito) ", "))
    (printout t crlf)
    (separador)
)
