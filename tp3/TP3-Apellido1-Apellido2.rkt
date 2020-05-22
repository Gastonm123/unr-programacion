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
; Circunferencia es (Number, Number, Number)
; Intepretación: El último elemento es el racio de la circunferencia, mientras que el primero y
; el segundo determinan la coordenada x y la coordenada y, del centro de la circunferencia, respectivamente.

; Circunferencias para pruebas
(define C1 (Circunferencia 0 0 2.5))
(define C2 (Circunferencia 3 4 2.5))
(define C3 (Circunferencia 5 0 5))

;Ejercicio 2
; distancia: Circunferencia Circunferencia -> Number
; distancia: Dadas dos circunferecias develve la distancia entre sus centros.
(check-expect (distancia C1 C2) 5)
(check-expect (distancia C1 C3) 5)

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



; tangentes-exteriores?: Define si dos circulos tienen un único punto en comun
; y no contiene una a la otra.
; tangentes-exteriores?: Circunferencia Circunferencia -> Boolean
(check-expect (tangentes-exteriores? C1 C2) #t)
(check-expect (tangentes-exteriores? C1 C3) #f)

(define (tangentes-exteriores? c c2)
  (=
   (distancia c c2)
   (+ (Circunferencia-radio c) (Circunferencia-radio c2))))


  
;Ejercicio 3
; crear-tangente-exterior: Circuferencia Integer -> Circunferencia
; crear-tangente-exterior: Dada una circunferencia C y un entero n mayor a 0, devuelve otra circunferencia C',
; que está a la derecha C, a la misma altura que C y es tangente exterior de C.
(check-error (crear-tangente-exterior C1 -1) "Error, n no es mayor a 0 y entero")
(check-error (crear-tangente-exterior C1 0.5) "Error, n no es mayor a 0 y entero")


(define (crear-tangente-exterior c n)
  (if (and (positive? n) (integer? n))
      (Circunferencia
       (+ (Circunferencia-x c) (Circunferencia-radio c) (* n (Circunferencia-radio c))) ; x
       (Circunferencia-y c) ; y
       (* n (Circunferencia-radio c)) ; radio
      )
      (error "Error, n no es mayor a 0 y entero")
   ))

(define C4 (crear-tangente-exterior C1 2))
(check-expect (= (Circunferencia-y C1) (Circunferencia-y C4)) #t)
(check-expect (tangentes-exteriores? C1 C4) #t)
(check-within (distancia C1 C4) 7.5 0.1)

(test)

