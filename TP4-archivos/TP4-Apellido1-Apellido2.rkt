;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname TP4-Apellido1-Apellido2) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
#|
Trabajo Práctico 4: Listas

Integrantes:
- Martinez Castro, Gaston, comisión 3.
- Peinado, Victoria, comisión 4.
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Datos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;; Diseño de datos

; Representaremos fechas mediante strings, según el formato aaaa-mm-dd.
; Representaremos los nombres de las localidades y departamentos mediante strings.
; Representaremos la cantidad de casos (sospechosos, descartados y confirmados)
; mediante números.

(define-struct notificacion [fecha loc conf desc sosp notif])
; notificacion es (String, String, Number, Number, Number, Number)
; Interpretación: un elemento en notificacion representa el conjunto de notificaciones
; registradas en una localidad (loc) hasta un día (fecha), en donde:
; - hay conf casos confirmados de COVID-19
; - hay desc casos descartados de COVID-19
; - sosp casos estaban en estudio.
; El último elemento, notif, indica la cantidad total de notificaciones.


;;;;;;;;;;;; Preparación de los Datos

;;;;;; Datos sobre localidades santafesinas

; Datos de entrada sobre localidades
(define INPUT-LOC (read-csv-file "dataset/santa_fe_departamento_localidad.csv"))
(define DATOS-LOC (rest INPUT-LOC))

; tomar-dos : List(X) -> List(X)
; Dada una lista l de dos o más elementos, tomar-dos calcula
; la lista formada por los dos primeros elementos de l, en
; ese orden.
(check-expect (tomar-dos (list "a" "b")) (list "a" "b")) 
(check-expect (tomar-dos (list 0 1 2 3)) (list 0 1))
(define
  (tomar-dos l)
  (list (first l) (second l)))

; Lista de localidades santafecinas
(define LISTA-LOC (map second DATOS-LOC))
; Lista de localidades santafecinas, con su departamento
(define LISTA-DPTO-LOC (map tomar-dos DATOS-LOC))

;;;;;; Datos sobre notificaciones de COVID-19

; Datos de entrada sobre notificaciones
(define INPUT-NOTIF (read-csv-file "dataset/notificaciones_localidad.csv"))
(define DATOS-NOTIF (rest INPUT-NOTIF))

; Lista de notificaciones
; [Completar, ejercicio 1]
; fila2noti : List(string) -> notificacion
; Dada una lista de strings, que representa una fila, devuelve una notificación
(check-expect (fila2noti (list "a" "b" "1" "2" "3" "4")) (make-notificacion "a" "b" 1 2 3 4))

(define
  (fila2noti fila)
  (make-notificacion (first fila)
                     (second fila)
                     (string->number(third fila))
                     (string->number(fourth fila))
                     (string->number(fifth fila))
                     (string->number(sixth fila))
 ))

 
(define LISTA-NOTIF (map fila2noti DATOS-NOTIF))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Consultas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define ANTES "2020-04-02")
(define HOY "2020-06-02")
(define LIMITE-CASOS 25)

;;;;;;;;;;;; Consulta 1

; [Completar, ejercicio 2-1]
; predicado-consulta1 : notificacion -> Boolean
; Dada una notificacion devuelve verdadero si la notificacion es de HOY
; y los casos superan LIMITE-CASOS
(check-expect (predicado-consulta1 (make-notificacion HOY "Rosario" 10 0 0 0)) #f)
(check-expect (predicado-consulta1 (make-notificacion HOY "Rosario" LIMITE-CASOS 0 0 0)) #t)

(define
  (predicado-consulta1 Notificacion)
  (and(string=? HOY (notificacion-fecha Notificacion))
      (>= (notificacion-conf Notificacion) LIMITE-CASOS))
 )

; localidades-limite-casos : List(notificacion) -> List(string)
; Dada una lista de notificaciones devuelve las localidades que evaluan
; verdadero al predicado-consulta1
(check-expect (localidades-limite-casos LISTA-NOTIF) (list "ROSARIO" "SANTA FE"))
(check-expect (localidades-limite-casos empty)  empty)
(check-expect (localidades-limite-casos (list (make-notificacion  HOY "Rosario" 30 0 0 0))) (list "Rosario"))
(define
  (localidades-limite-casos notificaciones)
  (map notificacion-loc (filter predicado-consulta1 notificaciones))
 )

; [Completar, ejercicio 2-2]
(define LOCALIDADES-LIMITE-CASOS (localidades-limite-casos  LISTA-NOTIF))
;;;;;;;;;;;; Consulta 2

; [Completar, ejercicio 3-1]
; borrar-repeticiones : List(string) -> List(string)
; Dado una lista de strings devuelve una lista con los mismos strings
; sin repeticiones
(check-expect (borrar-repeticiones (list "Rosario" "Rosario" "Firmat")) (list "Rosario" "Firmat"))
(check-expect (borrar-repeticiones (list "R" "R" "F" "F" "A")) (list "R" "F" "A"))
(check-expect (borrar-repeticiones empty) empty)

(define 
  (borrar-repeticiones lista)
  (cond [(empty? lista) empty]
        [else (cons (first lista) (borrar-repeticiones (remove-all (first lista) lista)))]
  ))

; listar-departamentos : List(List(string)) -> List(string)
; Dada una lista de departamentos y localidades devuelve una lista
; de los departamentos
(check-expect (listar-departamentos (list (list "BELGRANO" "ARMSTRONG") (list "BELGRANO" "BOUQUET"))) (list "BELGRANO" "BELGRANO"))
(check-expect (listar-departamentos empty) empty)
(check-expect (listar-departamentos (list empty)) empty)

(define
  (listar-departamentos lista)
  (cond [(empty? lista) empty]
        [(empty? (first lista)) empty]
        [else (cons (first(first lista)) (listar-departamentos (rest lista)))]
  ))

(define LISTA-DPTO (borrar-repeticiones (listar-departamentos LISTA-DPTO-LOC)))

; [Completar, ejercicio 3-2]
; listar-localidades-dpto : string List(List(string)) -> List(string)
; Dado un departamento y una lista de departamentos y localidades devuelve una
; lista de las localidades de ese departamento
(check-expect
 (listar-localidades-dpto "9 de Julio" LISTA-DPTO-LOC)
 (list "ESTEBAN RAMS" "GATO COLORADO" "GREGORIA PEREZ DE DENIS" "LOGROÑO"
       "MONTEFIORE" "POZO BORRADO" "SANTA MARGARITA" "TOSTADO" "VILLA MINETTI"))
(check-expect
 (listar-localidades-dpto "Belgrano" LISTA-DPTO-LOC)
 (list "ARMSTRONG" "BOUQUET" "LAS PAREJAS" "LAS ROSAS" "MONTES DE OCA" "TORTUGAS"))

(check-expect (listar-localidades-dpto "Belgrano" empty) empty)

(define
  (listar-localidades-dpto dpto lista)
  (cond [(empty? lista) empty]
        [else (if
               (string=? dpto (first(first lista)))
               (cons (second(first lista)) (listar-localidades-dpto dpto (rest lista)))
               (listar-localidades-dpto dpto (rest lista)))])
  )

; confirmados-dpto-fecha : string List(notificacion) -> number
; Dados una lista de notificaciones, un dpto y una fecha devuelve el total de casos confirmados
; en el dpto a la fecha. Las localidades del departamento que se cuentan son las de LISTA-DPTO-LOC
(check-expect (confirmados-dpto-fecha "Belgrano" HOY LISTA-NOTIF) 5)
(check-expect (confirmados-dpto-fecha "9 de Julio" HOY LISTA-NOTIF) 0)
(check-expect (confirmados-dpto-fecha "Belgrano" HOY empty) 0)
(define
  (confirmados-dpto-fecha dpto fecha lista)
  (cond [(empty? lista) 0]
        [else (if
               ; condicion
               (and
                (string=? (notificacion-fecha (first lista)) fecha)
                (member (notificacion-loc (first lista))
                        (listar-localidades-dpto dpto LISTA-DPTO-LOC)))
               ; si
               (+ (notificacion-conf (first lista)) (confirmados-dpto-fecha dpto fecha (rest lista)))
               ; sino
               (confirmados-dpto-fecha dpto fecha (rest lista)))]))

; [Completar, ejercicio 3-3]
; Funcion confirmados-por-dpto
; Dada una lista de notificaciones y una fecha devuelve una lista de listas de longitud
; dos conteniendo, en primera posicion un dpto. y en segundo lugar el numero de casos para
; ese departamento a la fecha. La lista contiene todos los departamentos de LISTA-DPTO
; Utilizamos una función auxiliar listar-confirmados-dpto que recursiona sobre la lista
; de departamentos
(check-expect (confirmados-por-dpto HOY LISTA-NOTIF)
              (list
               (list "9 de Julio" 0) (list "Belgrano" 5) (list "Caseros" 3) (list "Castellanos" 22)
               (list "Constitución" 9) (list "Garay" 3) (list "General López" 18) (list "General Obligado" 4)
               (list "Iriondo" 7) (list "La Capital" 37) (list "Las Colonias" 4) (list "Rosario" 124)
               (list "San Cristóbal" 0) (list "San Javier" 1) (list "San Jerónimo" 10) (list "San Justo" 0)
               (list "San Lorenzo" 17) (list "San Martín" 0) (list "Vera" 1)))
(check-expect (confirmados-por-dpto HOY empty)
              (list
               (list "9 de Julio" 0) (list "Belgrano" 0) (list "Caseros" 0) (list "Castellanos" 0)
               (list "Constitución" 0) (list "Garay" 0) (list "General López" 0) (list "General Obligado" 0)
               (list "Iriondo" 0) (list "La Capital" 0) (list "Las Colonias" 0) (list "Rosario" 0)
               (list "San Cristóbal" 0) (list "San Javier" 0) (list "San Jerónimo" 0) (list "San Justo" 0)
               (list "San Lorenzo" 0) (list "San Martín" 0) (list "Vera" 0)))

; listar-confirmados-dpto : string List(notificacion) List(string) -> List(List(string, number))
(define
  (listar-confirmados-dpto fecha lista-notif lista-dpto)
  (cond [(empty? lista-dpto) empty]
        [else (cons (list (first lista-dpto)
                          (confirmados-dpto-fecha (first lista-dpto) fecha lista-notif))
                    (listar-confirmados-dpto fecha lista-notif (rest lista-dpto)))]))

; confirmados-por-dpto : string List(notificacion) -> List(List(string, number))
(define
  (confirmados-por-dpto fecha lista)
  (listar-confirmados-dpto fecha lista LISTA-DPTO))

; [Completar, ejercicio 3-4]
(define CONFIRMADOS-DPTO-ANTES (confirmados-por-dpto ANTES LISTA-NOTIF))
(define CONFIRMADOS-DPTO-HOY (confirmados-por-dpto HOY LISTA-NOTIF))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Salidas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Datos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;; Diseño de datos

; Modelamos tablas como listas de filas
; Modelamos filas como una variable b' que puede ser lista de campos o String
; Modelamos los campos como una variable a' que puede ser String o Number

;;;;;;;;;;;; Consulta 1

; [Completar, ejercicio 4 - loc-lim-casos.csv]
; Función fila2string
; Dada una lista de campos devuelve un string representando la fila

; unir-campos : a' String -> String
; Es una funcion pensada para ser usada en un foldr
; Dados un campo y un string devuelve un string conteniendo al campo
; y al string
(check-expect "\"a\",b" (unir-campos "a" "b"))
(check-expect "\"0\",b" (unir-campos 0 "b"))

(define
  (unir-campos campo resto)
  (cond [(string? campo) (string-append "\"" campo "\"," resto)]
        [(number? campo) (string-append "\"" (number->string campo) "\"," resto)]
        [else ""]))

; fila2string : List(a') -> String
;Dada una lista devuelve un string formateado por la función unir-campos.
(check-expect "\"Manzana\",\"Pera\",\"Banana\"," (fila2string (list "Manzana" "Pera" "Banana")))
(check-expect "\"Manzanas\",\"2\"," (fila2string (list "Manzanas" "2")))
(check-expect "" (fila2string empty))

(define
  (fila2string fila)
  (foldr unir-campos "" fila))

; Funcion tabla2string
; Esta función recibe una lista de filas y devuelve un string formateado de la lista.
; Las filas pueden ser listas o strings, lo cual depende de los datos de entrada. En
; el caso de que una fila sea una lista, los elementos de la lista se separan con ","

; unir-filas : b' String -> String
; Es una funcion pensada para ser usada en un foldr
; Dados una fila y un string devuelve un string conteniendo a la fila
; y al string
(check-expect "\"ROSARIO\"\n\"SANTA FE\"\n" (tabla2string LOCALIDADES-LIMITE-CASOS))
(check-expect "\"Manzanas\",\"2\",\n" (tabla2string (list (list "Manzanas" 2))))

(define
  (unir-filas fila resto)
  (cond [(string? fila) (string-append "\"" fila "\"\n" resto)]
        [(list? fila) (string-append (fila2string fila) "\n" resto)]
        [else ""]))

; tabla2string : List(b') -> String
;Dada una lista devuelve un string formateado por la función unir-filas.
(check-expect (tabla2string (list "a" "b"))"\"a\"\n\"b\"\n")
(check-expect (tabla2string (list (list "a" "b"))) "\"a\",\"b\",\n")
(check-expect (tabla2string empty) "")
(define
  (tabla2string lista)
  (foldr unir-filas "" lista))

(define CABECERAS-LIM-CASOS "\"Localidad\"\n")
(write-file "loc-lim-casos.csv" (string-append CABECERAS-LIM-CASOS (tabla2string LOCALIDADES-LIMITE-CASOS)))

;;;;;;; Consulta 2

; [Completar, ejercicio 4 - casos-por-dpto-hoy.csv y casos-por-dpto-antes.csv]

(define CABECERAS-CONFIRMADOS "\"Departamento\",\"Confirmados\"\n")
(write-file "casos-por-dpto-hoy.csv" (string-append CABECERAS-CONFIRMADOS (tabla2string CONFIRMADOS-DPTO-HOY)))
(write-file "casos-por-dpto-antes.csv" (string-append CABECERAS-CONFIRMADOS (tabla2string CONFIRMADOS-DPTO-ANTES)))