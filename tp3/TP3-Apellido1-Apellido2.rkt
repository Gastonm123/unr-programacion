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
(define (distancia c c2)
   (sqrt
    (+
     (sqr(-
          (Circunferencia-x c)
          (Circunferencia-x c2)
      ))
     (sqr(-
          (Circunferencia-y c )
          (Circunferencia-y c2)
      ))
     )))
(define (tangentes-exteriores? c c2)
  (=
   (distancia c c2)
   (+ (Circunferencia-radio c ) (Circunferencia-radio c2))
   ))
  
;Ejercicio 3
(difine
 )
