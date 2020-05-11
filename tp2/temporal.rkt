#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require test-engine/racket-tests)

(define ALTO 500)
(define ANCHO 1015)
(define M-ALTO 250) ; mitad alto
(define ESCENA (empty-scene ANCHO ALTO))

; Función posicion-numero. Asigna a cada numero de 0 a 100 una posición
; posicion-numero Number -> Number
(check-expect(posicion-numero 0) 0)
(check-expect(posicion-numero 15) 150)
(check-expect(posicion-numero 100) 1000)

(define
  (posicion-numero num)
  (* num 10)
  )

; Función color-numero. Asigna un color a cada numero del 0 al 100
; color-numero: Number -> String
(check-expect (color-numero 100) "blue")
(check-expect (color-numero 13) "red")

(define
  (color-numero num)
  (if (= 0 (modulo num 2)) "blue" "red")
  )

; Función numero. Agrega un numero a la escena. La posicion y color del numero depende del mismo
; numero: Number String -> image?
(define
  (numero num)
  (place-image (text (number->string num) 18 (color-numero num)) (posicion-numero num) M-ALTO ESCENA)
  )

; Funcion dibujar. Por ahora solo muestra la escena vacía
; dibujar: Number -> image? 
(define (dibujar estado) (numero estado))

; Función avanzar. Avanza el estado de 0 a 100 aleatoriamente.
; Si se pasa un estado invalido se devuelve 50.
; avanzar-estado: Number -> Number
(check-random (avanzar 0) (random 101))
(check-expect (avanzar -1) 50)

(define
  (avanzar estado)
  (if (= -1 estado) 50 (random 101))
  )

; Función terminar?. Determina si el estado es multiplo de 8 que debe terminar
; terminar?: Number -> Boolean
(check-expect(terminar? 10) #false)
(check-expect(terminar? 8) #true)
(check-expect(terminar? 50) #false)

(define
  (terminar? estado)
  (if (= 0 (modulo estado 8)) #true #false)
  )

(test)

(big-bang -1
  [state #t]
  [on-tick avanzar 2]
  [on-draw dibujar]
  [stop-when terminar?]
  [close-on-stop #t]
  )