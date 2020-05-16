(clear)

(defglobal ?*debug-print* = t) ;nil vs t

(load protege/ontologia_sbc.pont)
(load-instances protege/ontologia_sbc.pins)

(reset)

(load functions.clp)
(load rules.clp)

(run)
