;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname TP5-Apellido1-Apellido2) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
#|
Trabajo Práctico 5: Naturales

Integrantes:
- [Apellido, Nombre], comisión [número_comisión].
- [Apellido, Nombre], comisión [número_comisión].
|#


;;;;;;;; Ejercicio 1
; representamos la cantidad de escalones con un natural
; subir: Natural->Natural
; dada la cantidad de escalones devuelve la cantidad de formas diferentes en las que podes subir la escalera
(check-expect (subir 1)1)
(check-expect (subir 0) 1)
(check-expect (subir 2) 1)
(check-expect (subir 3) 2)
(check-expect (subir 4) 3)
(check-expect (subir 5) 5)
(check-expect (subir 6) 8)
(define
  (subir x)
  (cond [(zero? x) 1]
        [(negative? x) 0]
        [else (+ (subir (- x 5))(subir (- x 3))(subir (- x 1)))]
    )
)


;;;;;;;; Ejercicio 2

;;;; Ejercicio 2-1

; Costo de los recorridos válidos:
; * [Completar]
; * [Completar]
; * [Completar]
; * [Completar]
; * [Completar]
; * [Completar]
; * [Completar]
; * [Completar]
; * [Completar]
; * [Completar]

;;;; Ejercicio 2-2
#|
                    /    tab[0][0]     si i = 0, j = 0
                    |   tab[0][j] + maximoCosto(i,j-1)    si i = 0, j != 0
maximoCosto(i, j) = <
                    |   tab[i][0] + maximoCosto(i-1,j)    si i != 0, j = 0
                    \   tab[i][j] + maximo( maximoCosto(i-1,j),maximoCosto(i,j-1))    si i != 0, j != 0


|#

;;;; Ejercicio 2-3

(define TABLERO (list (list -5 10) (list 0 -2) (list 9 3)))

(define (valor tab i j)
  (list-ref (list-ref tab i)j))

(define
  (maximo-costo tab i j)
  (cond [(= 0 i j) (valor tab i j)]
        [(= 0 i) (+ (valor tab i j) (maximo-costo tab i (- j 1)))]
        [(= 0 j) (+ (valor tab i j) (maximo-costo tab (- i 1) j))]
        [else (+ (valor tab i j) (max (maximo-costo tab i (- j 1)) (maximo-costo tab (- i 1) j)))]
        )
  )

;;;; Ejercicio 2-4

; [COMPLETAR]