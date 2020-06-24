;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname TP5-Apellido1-Apellido2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
#|
Trabajo Práctico 5: Naturales

Integrantes:
- [Apellido, Nombre], comisión [número_comisión].
- [Apellido, Nombre], comisión [número_comisión].
|#


;;;;;;;; Ejercicio 1

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
                    |   [Completar]    si i = 0, j != 0
maximoCosto(i, j) = <
                    |   [Completar]    si i != 0, j = 0
                    \   [Completar]    si i != 0, j != 0
|#

;;;; Ejercicio 2-3

(define TABLERO (list (list -5 10) (list 0 -2) (list 9 3)))

; [COMPLETAR]

;;;; Ejercicio 2-4

; [COMPLETAR]