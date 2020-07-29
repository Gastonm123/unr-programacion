;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname TP6-Apellido1-Apellido2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
#| Trabajo Práctico 6

Integrantes:
- [Martinez Castro, Gaston], comisión 3.
- [Peinado, Victoria], comisión 4.
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

; crear-fila: Integer Integer -> List(Integer)
; Funcion crear-fila. La funcion tomar fila toma un numero indicando
; la fila y la cantidad de variables y devuelve una lista con el estado
; de las variables para esa fila
(check-expect (crear-fila 1 1) (list #false))
(check-expect (crear-fila 0 1) (list #true))
(check-expect (crear-fila 0 2) (list #true #true))
(check-expect (crear-fila 3 2) (list #false #false))
(define
  (crear-fila fila n)
  (cond [(= n 0) empty]
        [else
        (cons (zero?(remainder fila 2)) (crear-fila(quotient fila 2) (- n 1)))]))

; crear-valuaciones: Integer Integer -> List(List(Integer))
; Funcion crear-valuaciones. La función toma un numero de variables 
; y un numero de filas y devuelve una lista con todos los estados no
; repetidos para cada variables
(check-expect (crear-valuaciones 1 1) (list (list #false) (list #true)))
(check-expect (crear-valuaciones 2 3) (list (list #false #false) (list #false #true) (list #true #false) (list #true #true)))
(define
  (crear-valuaciones n filas)
  (cond [(= filas 0) (cons (crear-fila filas n) empty)]
        [else (cons(reverse (crear-fila filas n))(crear-valuaciones n (- filas 1 ) ))]))

; valuaciones: Integer -> List(List(Integer))
; Funcion valuaciones. La función toma un numero de variables y devuelve
; todos los estados posibles, no repetidos, para cada variable.
(check-expect (valuaciones 1) (list (list #false) (list #true)))
(check-expect (valuaciones 2) (list (list #false #false) (list #false #true) (list #true #false) (list #true #true)))
(define
  (valuaciones n)
  (crear-valuaciones n (-(expt 2 n) 1)))
  

;;;;;;;; Ejercicio 3

; A : List(Boolean) -> Boolean
; B : List(Boolean) -> Boolean
; C : List(Boolean) -> Boolean
; Funciones A, B y C representando formulas proposicionales proporsionadas
; para el ejercicio

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

; D: List(Boolean) -> Boolean
; Funcion D. Representa la ecuacion proposicional p /\ ~p 
(define
  (D l)
  (let ([p (first l)])
  (and p (not p))))

; D: List(Boolean) -> Boolean
; Funcion E. Representa la ecuación proposicional p <-> q
(define 
  (E l)
  (let ([p (first l)]
        [q (second l)])
  (equivalente p q)))

;;;;;;;; Ejercicio 4

; evaluar: List(Boolean) -> Boolean Integer -> List(Boolean)
; Función evaluar. Toma una función representando una formula proposicional
; y la cantidad de variables y devuelve una lista de resultados para todas
; las valuaciones de las variables.
(check-expect (evaluar A 3) (list #true #true #true #true #true #true #true #true))
(check-expect (evaluar B 3) (list #true #true #false #true #false #true #true #true))
(check-expect (evaluar C 2) (list #false #false #false #false))
(check-expect (evaluar D 1) (list #false))
(check-expect (evaluar E 2) (list #true #false #false #true))
(define
  (evaluar P n)
  (map P (valuaciones n)))

;;;;;;;; Ejercicio 5

; Y: Boolean Boolean -> Boolean
; Funcion Y. Toma dos booleanos y devuelve al and de ambos
(define (Y x y )(and x y))

; tautologia?: List(Boolean) -> Boolean Integer -> Boolean
; Funcion tautologia?. Toma una función representando una formula proposicional
; y la cantidad de variables e informa si es una tautología.
(check-expect (tautología? A 3) #true)
(check-expect (tautología? B 3) #false)
(check-expect (tautología? C 2) #false)
(check-expect (tautología? D 1) #false)
(check-expect (tautología? E 2) #false)
(define
  (tautología? P n)
  (foldr Y #t(evaluar P n)))

; O: Boolean Boolean -> Boolean
; Funcion O. Toma dos booleanos y devuelve el or de ambos
(define (O x y )(or x y))

; satisfactible?: List(Boolean) -> Boolean Integer -> Boolean
; Funcion satisfactible?. Toma una función representado una formala proposicional
; y la cantidad de variables e informa si es satisfactible.
(check-expect (satisfactible? A 3) #true)
(check-expect (satisfactible? B 3) #true)
(check-expect (satisfactible? C 2) #false)
(check-expect (satisfactible? D 1) #false)
(check-expect (satisfactible? E 2) #true)
(define
  (satisfactible? P n)
  (foldr O #f(evaluar P n)))

; contradiccion?: List(Boolean) -> Boolean Integer -> Boolean
; Funcion contradiccion?. Toma una función representando una formula proposicional
; y la cantidad de variable e informa si es una contradiccion.
(check-expect (contradiccion? A 3) #false)
(check-expect (contradiccion? B 3) #false)
(check-expect (contradiccion? C 2) #true)
(check-expect (contradiccion? D 1) #true)
(check-expect (contradiccion? E 2) #false)
(define
  (contradiccion? P n)
  (not (satisfactible? P n)))