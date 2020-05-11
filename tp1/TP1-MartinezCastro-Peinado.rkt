;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname TP1-MartinezCastro-Peinado) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
#|
Trabajo Práctico 1: Receta para el diseño

Integrantes:
- Martínez Castro, Gaston, comisión 3.
- Peinado, Victoria, comisión 4.
|#


(define TIPO1 16)
(define TIPO2 12)
(define VOLBALDE 2)

; Ejercicio 1
;Representamos areas, volumenes  y tipos de pintura mediante numeros.
;Siendo 1 un metro al cuadrado, un un lito. Y el numero de un tipo de pintura los metros cuadrados que se pueden pintar por litro.

;pintura-necesaria: Number Number Number Number -> Number

;Dados cuatro numeros, sean:
;los dos primeros las dimensiones de la base,
;el tercero la pofundiad de una pileta,
;y el ultimo el area que puede pintar un litro de un tipo de pintura.
;Calcula los litros necesarios para pintar la pileta.

(check-expect(pintura-necesaria 1 1 1 TIPO1) 5/16)
(check-expect(pintura-necesaria 1 1 2 TIPO1) 9/16)
(check-expect(pintura-necesaria 1 3 1 TIPO1) 11/16)
(check-expect(pintura-necesaria 4 1 1 TIPO1) 14/16)
(check-expect(pintura-necesaria 4 3 2 TIPO1) 40/16)
(check-expect(pintura-necesaria 1 1 1 TIPO2) 5/12)
(check-expect(pintura-necesaria 4 3 2 TIPO2) 40/12)

(define
  (pintura-necesaria x y z tipo)
  (/ (+ (* x y) (* 2 x z) (* 2 y z))
     tipo
   )
 )
; Ejercicio 2
;Representamos areas, volumenes, cantidades de baldes y tipos de pintura mediante numeros.
;Siendo 1 un metro al cuadrado, un un lito o un balde. Y el numero de un tipo de pintura los metros cuadrados que se pueden pintar por litro.

; balance-pintura: Number Number Numer Number Number -> Number

;Dados cinco numeros, sean:
;los dos primeros las dimensiones de la base,
;el tercero la pofundiad de una pileta,
;el cuarto el area que puede pintar un litro de un tipo de pintura,
;y el cinto la cantidad de valdes disponibles.
;Devuelve un numero positivo o negativo dependiendo del numero de baldes sobrantes.
;Si el valor de retorno es negativo, faltan baldes y si el valor es positivo sobran baldes
(check-expect(balance-pintura 1 1 1 TIPO2 1) 0)
(check-expect(balance-pintura 4 3 2 TIPO2 1) -1)
(check-expect(balance-pintura 4 3 2 TIPO2 0) -2)
(check-expect(balance-pintura 4 1 1 TIPO1 2) 1)
(check-expect(balance-pintura 4 1 1 TIPO1 3) 2)

(define
  (balance-pintura x y z tipo baldes)
  (floor(/ (- (* VOLBALDE baldes) (pintura-necesaria x y z tipo)) VOLBALDE))
 )

; chequeo-pintura: Number Number Number Number Number -> String

;Dados cinco numeros, sean:
;los dos primeros las dimensiones de la base,
;el tercero la pofundiad de una pileta,
;el cuarto el area que puede pintar un litro de un tipo de pintura,
;y el cinto la cantidad de valdes disponibles.
;Devuelve un string que informa si sobran, faltan o estan justos los baldes para pintar la pileta.
(check-expect(chequeo-pintura 1 1 1 TIPO2 1) "Cantidad justa.")
(check-expect(chequeo-pintura 4 3 2 TIPO2 1) "Falta 1 balde.")
(check-expect(chequeo-pintura 4 3 2 TIPO2 0) "Faltan 2 baldes.")
(check-expect(chequeo-pintura 4 1 1 TIPO1 2) "Sobra 1 balde.")
(check-expect(chequeo-pintura 4 1 1 TIPO1 3) "Sobran 2 baldes.")

(define
  (chequeo-pintura x y z tipo baldes)
  (cond [(= 0 (balance-pintura x y z tipo baldes)) "Cantidad justa."]
        [(= 1 (balance-pintura x y z tipo baldes)) "Sobra 1 balde."]
        ; la condicion es que el balance > 1, por la forma prefija de racket el simbolo va al reves
        [(< 1 (balance-pintura x y z tipo baldes))
         (string-append
          "Sobran "
          (number->string(balance-pintura x y z tipo baldes))
          " baldes.")]
        [(= -1 (balance-pintura x y z tipo baldes)) "Falta 1 balde."]
        ; la condicion es que el balance < -1, por la forma prefija de racket el simbolo va al reves
        [(> -1 (balance-pintura x y z tipo baldes))
         (string-append
          "Faltan "
          (number->string(abs (balance-pintura x y z tipo baldes)))
          " baldes.")]
   )
)

; Ejercicio 3
; La función del apartado 1 resulto de ultilidad para resolver el apartado
; 2 devido a que en el apartado 2 nos encontramos con el mismo problema que
; en el apartado 1 pero con mayor complejidad. Entonces es util reusar la
; funcionalidad del apartado 1 para hacer el apartado 2.
; Si no se hubiese pedido diseñar la función del apartado 1 aun así sería
; conveniente diseñarla ya que simplifica la complejidad del apartado 2 al
; abstraer los detalles de implementación del calculo de la función final
; función del apartado 2. Además, al tener más de una función estas se
; pueden testear individualmente y así tener mas certeza de su correcto
; funcionamiento.


;Tambien tepresentamos tipos de pintura mediante posn del tipo (x,y)
;Siendo x e y numeros,
;x es la cantidad de metros que se pueden pintar con 1 litro
;y es la cantidad de litos que vienen por baldes
;(define T1 (make-posn 16 2))
;(define T2 (make-posn 12 2))