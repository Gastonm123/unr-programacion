#lang racket
#|
Trabajo Práctico 3: Estructuras

Integrantes:
- [Apellido, Nombre], comisión [número_comisión].
- [Apellido, Nombre], comisión [número_comisión].
|#

(require test-engine/racket-tests)

;Ejercicio 1
(struct Circunferencia (x y radio))

; Circunferencias para pruebas
(define C1 (Circunferencia 0 0 2.5))
(define C2 (Circunferencia 3 4 2.5))
(define C3 (Circunferencia 5 0 5))

;Ejercicio 2
;distancia: Circunferencia Cirdunfe
(define (distancia c c2)
  (sqrt
   (+
    (sqr(-
         (Circunferencia-x c)
         (Circunferencia-x c2)
     ))
    (sqr(-
         (Circunferencia-y c)
         (Circunferencia-y c2)
     ))
    )))

; tangentes-exteriores?: Define si dos circulos tienen un unico punto en comun
; y no contiene una a la otra.
; tangentes-exteriores?: Circunferencia Circunferencia -> Boolean
(define (tangentes-exteriores? c c2)
  (=
   (distancia c c2)
   (+ (Circunferencia-radio c) (Circunferencia-radio c2))))

(check-expect (tangentes-exteriores? C1 C2) #t)
(check-expect (tangentes-exteriores? C1 C3) #f)
  
;Ejercicio 3
(define (crear-tangente-exterior c n)
  (Circunferencia
   (+ (Circunferencia-x c) (Circunferencia-radio c) (* n (Circunferencia-radio c))) ; x
   (Circunferencia-y c) ; y
   (* n (Circunferencia-radio c)) ; radio
  ))

(test)