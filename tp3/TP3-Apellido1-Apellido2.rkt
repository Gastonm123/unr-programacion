#lang racket
#|
Trabajo Práctico 3: Estructuras

Integrantes:
- [Apellido, Nombre], comisión [número_comisión].
- [Apellido, Nombre], comisión [número_comisión].
|#

;Ejercicio 1
(struct Circunferencia (x y radio))

;Ejercicio 2
; distancia: Circunferencia Cirdunferencia -> Number
; dadas dos circunferecias develve la distancia entre sus centros
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

(define (tangentes-exteriores? c c2)
  (=
   (distancia c c2)
   (+ (Circunferencia-radio c) (Circunferencia-radio c2))))
  
;Ejercicio 3
; Circuferencia Number -> Circunferencia
; dada una circunferencia
(check-error ( -1) "Error el n es menor que 0")
(define (crear-tangente-exterior c n)
  (if (positive? n)
      (Circunferencia
       (+ (Circunferencia-x c) (Circunferencia-radio c) (* n (Circunferencia-radio c))) ; x
       (Circunferencia-y c) ; y
       (* n (Circunferencia-radio c)) ; radio
      )
      (error "Error el n es menor que 0")
   ))
