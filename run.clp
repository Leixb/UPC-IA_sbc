(clear)

(load protege/ontologia_sbc.pont)
(definstances instancias
    (load protege/ontologia_sbc.pins)
)

(reset)

(load ontologia_sbc_functions.clp)
(load ontologia_sbc_rules.clp)

(run)
(exit)
