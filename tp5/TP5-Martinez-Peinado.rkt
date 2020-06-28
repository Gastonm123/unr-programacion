;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname TP5-Martinez-Peinado) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
#|
Trabajo Práctico 5: Naturales

Integrantes:
- Martinez Castro, Gaston, comisión 3.
- Peinado, Victoria, comisión 4.
|#

;;;;;;;;;;;; Diseño de datos

; Representamos la cantidad de escalones con un natural
; Representamos un mapa con una lista de listas

;;;;;;;; Ejercicio 1

; subir: Natural -> Natural
; Dada la cantidad de escalones devuelve la cantidad de formas diferentes en las que podes subir la escalera
; subiendo de a 1 escalon, de a 3 escalones y de a 5 escalones
(check-expect (subir 1) 1)
(check-expect (subir 0) 1)
(check-expect (subir 2) 1)
(check-expect (subir 3) 2)
(check-expect (subir 4) 3)
(check-expect (subir 5) 5)
(check-expect (subir 6) 8)
(define
  (subir x)
  (cond [(>= x 5) (+ (subir (- x 5))(subir (- x 3))(subir (- x 1)))] 
        [(>= x 3) (+ (subir (- x 3))(subir (- x 1)))]
        [(>= x 1) (+ (subir (- x 1)))]
        [(zero? x) 1]
    )
)


;;;;;;;; Ejercicio 2

;;;; Ejercicio 2-1

; Costo de los recorridos válidos:
; Recorrido 1 : (0,0) (1,0) (2,0) (3,0) (3,1) (3,2). Costo : 20 
; Recorrido 2 : (0,0) (1,0) (2,0) (2,1) (3,1) (3,2). Costo : 13
; Recorrido 3 : (0,0) (1,0) (2,0) (2,1) (2,2) (3,2). Costo : 12
; Recorrido 4 : (0,0) (1,0) (1,1) (2,1) (3,1) (3,2). Costo : 21
; Recorrido 5 : (0,0) (1,0) (1,1) (2,1) (2,2) (3,2). Costo : 20
; Recorrido 6 : (0,0) (1,0) (1,1) (1,2) (2,2) (3,2). Costo : 21
; Recorrido 7 : (0,0) (0,1) (1,1) (2,1) (3,1) (3,2). Costo : 18
; Recorrido 8 : (0,0) (0,1) (1,1) (2,1) (2,2) (3,2). Costo : 17
; Recorrido 9 : (0,0) (0,1) (1,1) (1,2) (2,2) (3,2). Costo : 18
; Recorrido 10: (0,0) (0,1) (0,2) (1,2) (2,2) (3,2). Costo : -2

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

; valor : List(List Number) Natural Natural -> Number
; Funcion valor toma una lista de listas y dos indices y devuelve el
; valor en el indice [i][j]
(check-expect (valor TABLERO 0 0) -5)
(check-expect (valor TABLERO 1 1) -2)
(define (valor tab i j)
  (list-ref (list-ref tab i) j))

; valor-seguro : List(List Number) Natural Natural -> Number
; Funcion valor-seguro valida que los indices pasados a la funcion
; valor sean validos
(check-error (valor-seguro TABLERO 0 2) "Indice muy grande")
(check-error (valor-seguro TABLERO 3 1) "Indice muy grande")
(check-error (valor-seguro empty   0 0) "Indice muy grande")
(define (valor-seguro tab i j)
  (cond [(<= (length tab) i) (error "Indice muy grande")]
        [(<= (length (first tab)) j) (error "Indice muy grande")]
        [else (valor tab i j)]))

; maximo-costo : List(List Number) Number Number -> Number
; Funcion maximo-costo toma un mapa y la posicion a la que se quiere llegar
; y devuelve el maximo costo para llegar a esa posicion desde la posicion (0,0)
(check-expect (maximo-costo TABLERO 0 0) -5)
(check-expect (maximo-costo TABLERO 1 1) 3)
(define
  (maximo-costo tab i j)
  (cond [(= 0 i j) (valor-seguro tab i j)]
        [(= 0 i) (+ (valor-seguro tab i j) (maximo-costo tab i (- j 1)))]
        [(= 0 j) (+ (valor-seguro tab i j) (maximo-costo tab (- i 1) j))]
        [else (+ (valor-seguro tab i j) (max (maximo-costo tab i (- j 1)) (maximo-costo tab (- i 1) j)))]
        )
  )

;;;; Ejercicio 2-4

; maximo-costo-tablero : List(List Number) -> Number
; Funcion maximo-costo-tablero toma un mapa y devuelve el maximo costo para llegar
; desde la posicion (0,0) a la posicion (x-1,y-1) con x,y las dimensiones del mapa
(check-expect (maximo-costo-tablero TABLERO) 7)
(define
  (maximo-costo-tablero tab)
  (maximo-costo tab (- (length tab) 1) (- (length(first tab)) 1))
 )