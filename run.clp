(clear)

(defglobal ?*debug-print* = t) ;nil vs t

(load protege/ontologia_sbc.pont)

(load functions.clp)
(load rules.clp)

(reset)

(load-instances protege/ontologia_sbc.pins)

(run)
