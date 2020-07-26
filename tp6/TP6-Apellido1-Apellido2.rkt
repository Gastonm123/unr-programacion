;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname TP6-Apellido1-Apellido2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
#| Trabajo Práctico 6

Integrantes:
- [Apellido, Nombre], comisión [número_comisión].
- [Apellido, Nombre], comisión [número_comisión].
|#

;;;;;;;; Ejercicio 1

; implica : Boolean Boolean -> Boolean
; dados dos booleanos debuelve el reultado de la implicación entre ambos
(check-expect  (implica #t #t) #t)
(check-expect  (implica #t #f) #f)
(check-expect  (implica #f #t) #t)
(check-expect  (implica #f #f) #t)

(define
  (implica p q)
  (cond [(false? p) #t]
        [else q]))

; equivalente : Boolean Boolean -> Boolean
; dados dos booleanos debuelve el reultado de la equivalencia entre ambos
(check-expect  (equivalente #t #t) #t)
(check-expect  (equivalente #t #f) #f)
(check-expect  (equivalente #f #t) #f)
(check-expect  (equivalente #f #f) #t)

(define
  (equivalente p q)
  (cond [(equal? p q) #t]
        [ else #f]))

;;;;;;;; Ejercicio 2

; [Completar]
(define
  (crear-fila pos n)
  (cond [(= n 0) empty]
        [else
        (cons (zero?(remainder pos 2)) (crear-fila(quotient pos 2) (- n 1)))]))

(define
  (crear-valuaciones n filas)
  (cond [(= filas 0) (cons (crear-fila filas n) empty)]
        [else (cons(reverse (crear-fila filas n))(crear-valuaciones n (- filas 1 ) ))]))

(define
  (valuaciones n)
  (crear-valuaciones n (-(expt 2 n) 1)))
  

;;;;;;;; Ejercicio 3

; A : List(Boolean) -> Boolean
(define
  (A l)
  (let ([p1 (first l)]
        [p2 (second l)]
        [p3 (third l)])
  (equivalente (and (implica p1 p3)
                    (implica p2 p3))
               (implica (or p1 p2)
                        p3))))
(define
  (B l)
  (let ([p1 (first l)]
        [p2 (second l)]
        [p3 (third l)])
  (equivalente(implica (and p1 p2)
                       p3)
              (and (implica p1 p3)
                    (implica p2 p3)))))
(define
  (C l)
  (let ([p1 (first l)]
        [p2 (second l)])
  (equivalente(or (not p1)(not p2))
              (and p1 p2))))

(define  valuacion-B (B (list #t #t #t)))
(define  valuacion-C (C (list #t #t)))


;;;;;;;; Ejercicio 4

(define
  (evaluar P n)
  (map P (valuaciones n)))

;;;;;;;; Ejercicio 5

; [Completar]
