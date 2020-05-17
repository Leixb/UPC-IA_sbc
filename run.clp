(clear)

(defglobal ?*debug* = TRUE)
(defglobal ?*debug-print* = (if ?*debug* then t else nil))

(if ?*debug* then
    (printout t "=> !!! Running in DEBUG mode" crlf)
)

(load protege/ontologia_sbc.pont)

(load functions.clp)
(load rules.clp)

(reset)

(load-instances protege/ontologia_sbc.pins)

(run)
