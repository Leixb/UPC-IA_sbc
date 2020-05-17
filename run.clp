(clear)

(defglobal ?*debug* = FALSE)
(defglobal ?*debug-print* = (if ?*debug* then t else nil))

(load protege/ontologia_sbc.pont)

(load functions.clp)
(load rules.clp)

(printout ?*debug-print* "test" crlf)

(reset)

(load-instances protege/ontologia_sbc.pins)

(run)
