(make-instance ej1 of ejercicio_con_repeticiones
    (dificultad_ejercicio normal)
    (ejercicio_a_repetir [ontologia_sbc_Class2])
    (repeticiones 1)
)
(make-instance ej2 of ejercicio_con_repeticiones
    (dificultad_ejercicio normal)
    (ejercicio_a_repetir [ontologia_sbc_Class3])
    (repeticiones 1)
)
(make-instance ej3 of ejercicio_con_repeticiones
    (dificultad_ejercicio moderada)
    (ejercicio_a_repetir [ontologia_sbc_Class4])
    (repeticiones 10)
)

(make-instance programa of programa_de_entrenamiento
    (ej_lunes [ej1] [ej2])
    (ej_martes [ej3])
    (ej_miercoles [ej2])
    (ej_jueves [ej1])
    (ej_viernes)
    (ej_sabado [ej3] [ej2])
    (ej_domingo)
)
(send [programa] imprimir)
