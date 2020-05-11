#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require test-engine/racket-tests)

;El estado del big-bang serán números

(define ALTO 500)
(define ANCHO 1020)
(define M-ALTO 250); Mitad del alto
(define ESCENA (empty-scene ANCHO ALTO))


; Función posicion-numero. Asigna a cada numero de 0 a 100 una posición
; posicion-numero Number -> Number
(check-expect(posicion-numero 0) 5)
(check-expect(posicion-numero 15) 155)
(check-expect(posicion-numero 100) 1005)

(define
  (posicion-numero num)
  (+ (* num 10) 5)
  )

; Función color-numero. Asigna un color a cada numero del 0 al 100
; color-numero: Number -> String
(check-expect (color-numero 100) "blue")
(check-expect (color-numero 13) "red")

(define
  (color-numero num)
  (if (= 0 (modulo num 2)) "blue" "red")
  )

; Utilizamos números para representa el texto que se mostrara en pantalla
; Función numero. Agrega un numero a la escena. La posicion y color del numero depende del mismo
; numero: Number String -> image?
(define
  (numero num)
  (place-image (text (number->string num) 18 (color-numero num)) (posicion-numero num) M-ALTO ESCENA)
  )

; Utilizamos números para representa el texto que se mostrara en pantalla
; Funcion dibujar. Por ahora solo muestra la escena vacía
; dibujar: Estado -> image? 
(define
  (dibujar estado)
  (numero estado)
  )

; Utilizamos un número(101) para representar un intervalo([0,100]).
; Función avanzar. Avanza el estado a un numero del itervalo [0,100] aleatoriamente.
; Si es el estado inicial devuelve 50.
; avanzar-estado: Number -> Number
(check-random (avanzar 0) (random 101))
(check-expect (avanzar -1) 50)

(define
  (avanzar estado)
  (if (= -1 estado) 50 (random 101))
  )

; Función terminar?: Determina si el estado es multiplo de 8 que debe terminar
; terminar?: Number -> Boolean
(check-expect(terminar? 10) #false)
(check-expect(terminar? 8) #true)
(check-expect(terminar? 50) #false)

(define
  (terminar? estado)
  (if (= 0 (modulo estado 8)) #true #false)
  )


; Función manejar-teclado:si se presiona la flecha derecha el estado pasa a ser 100,
; si se presiona la flecha izquierda el estado pasa a ser 0.

; manejar-teclado: Number Key-event -> Number
(check-expect(manejar-teclado 12 "left") 0)
(check-expect(manejar-teclado 12 "right") 100)
(define
  (manejar-teclado estado key) (cond
                                 [(key=? key "left") 0]
                                 [(key=? key "right") 100]))


(big-bang -1
  ;[state #t]
  [on-tick avanzar 2]
  [on-draw dibujar]
  [on-key manejar-teclado]
  [stop-when terminar? dibujar]
  [close-on-stop 3]
  )

(test)