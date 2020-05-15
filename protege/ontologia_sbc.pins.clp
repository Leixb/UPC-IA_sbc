(definstances instancias
; Fri May 15 21:46:24 CEST 2020
; 
;+ (version "3.5")
;+ (build "Build 663")

([ontologia_sbc_Class1] of  objetivo

	(nombre_objetivo "Ganar fuerza"))

([ontologia_sbc_Class10] of  objetivo

	(nombre_objetivo "Ganar resistencia"))



([ontologia_sbc_Class13] of  probelma_musculo-esqueletico

	(nombre_problema "Dolor de espalda"))

([ontologia_sbc_Class14] of  probelma_musculo-esqueletico

	(nombre_problema "Dolor de articulaciones"))

([ontologia_sbc_Class15] of  probelma_musculo-esqueletico

	(nombre_problema "Dolor de cervicales"))

([ontologia_sbc_Class16] of  dieta

	(nombre_dieta "Consumo de fruta diariamente"))

([ontologia_sbc_Class17] of  dieta

	(nombre_dieta "Abuso de sal"))

([ontologia_sbc_Class18] of  dieta

	(nombre_dieta "Picar entre horas"))

([ontologia_sbc_Class2] of  ejercicio

	(calorias 517)
	(combina_con
		[ontologia_sbc_Class4]
		[ontologia_sbc_Class3])
	(dificultad 4)
	(duracion_max 1)
	(duracion_min 3)
	(ejercicio_cubre_un
		[ontologia_sbc_Class1]
		[ontologia_sbc_Class8])
	(nombre_ejercicio "Dominadas")
	(repeticiones_max 20)
	(repeticiones_min 4))

([ontologia_sbc_Class3] of  ejercicio

	(calorias 320)
	(combina_con
		[ontologia_sbc_Class2]
		[ontologia_sbc_Class4])
	(dificultad 7)
	(duracion_max 4)
	(duracion_min 1)
	(ejercicio_cubre_un [ontologia_sbc_Class1])
	(nombre_ejercicio "Remo 90")
	(repeticiones_max 14)
	(repeticiones_min 4))

([ontologia_sbc_Class4] of  ejercicio

	(calorias 490)
	(combina_con
		[ontologia_sbc_Class3]
		[ontologia_sbc_Class2])
	(dificultad 9)
	(duracion_max 12)
	(duracion_min 4)
	(ejercicio_cubre_un [ontologia_sbc_Class1])
	(nombre_ejercicio "Peso muerto")
	(repeticiones_max 12)
	(repeticiones_min 4))

([ontologia_sbc_Class5] of  ejercicio

	(calorias 600)
	(combina_con
		[ontologia_sbc_Class4]
		[ontologia_sbc_Class3]
		[ontologia_sbc_Class2]
		[ontologia_sbc_Class7])
	(dificultad 5)
	(duracion_max 120)
	(duracion_min 10)
	(ejercicio_cubre_un
		[ontologia_sbc_Class10]
		[ontologia_sbc_Class8])
	(nombre_ejercicio "Cardio en cinta a velocidad media alta")
	(repeticiones_max 1)
	(repeticiones_min 1))

([ontologia_sbc_Class7] of  ejercicio

	(calorias 150)
	(dificultad 3)
	(duracion_max 5)
	(duracion_min 2)
	(ejercicio_cubre_un [ontologia_sbc_Class9])
	(nombre_ejercicio "Estiramiento dinámico de piernas")
	(repeticiones_max 30)
	(repeticiones_min 15))

([ontologia_sbc_Class8] of  objetivo

	(nombre_objetivo "Mantenerse en forma"))

([ontologia_sbc_Class9] of  objetivo

	(nombre_objetivo "Ganar flexibilidad"))
)
