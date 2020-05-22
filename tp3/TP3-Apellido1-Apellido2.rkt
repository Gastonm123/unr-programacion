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

(check-expect (distancia C1 C2) 5)
(check-expect (distancia C1 C3) 5)

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


(define C4 (crear-tangente-exterior C1 2))
(check-expect (= (Circunferencia-y C1) (Circunferencia-y C4)) #t)
(check-expect (tangentes-exteriores? C1 C4) #t)
(check-within (distancia C1 C4) 7.5 0.1)

(test)

