;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname TP4-Apellido1-Apellido2) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
#|
Trabajo Práctico 4: Listas

Integrantes:
- [Apellido, Nombre], comisión [número_comisión].
- [Apellido, Nombre], comisión [número_comisión].
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
; fila2noti : List(string) -> List(notificacion)
; Dada una lista de string, que representa una fila, devuelve una notificación
(define
  (fila2noti fila)
  (make-notificacion (first fila) (second fila) (third fila) (fourth fila) (fifth fila) (sixth fila))
 )
(define LISTA-NOTIF(map fila2noti DATOS-NOTIF))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Consultas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define ANTES "2020-04-02")
(define HOY "2020-06-02")
(define LIMITE-CASOS 25)

;;;;;;;;;;;; Consulta 1

; [Completar, ejercicio 2-1]
#|(define
  (dia=dia Notificacion)
  (string=? HOY (notificacion-fecha Notificacion))
 )
(define
  (casos>=limite Notificacion)
  (>= (string->number(notificacion-conf Notificacion)) LIMITE-CASOS)
 )
(define NOTIFICACIONES-HOY (filter dia=dia LISTA-NOTIF))
(define CONSULTA1 (filter casos>=limite NOTIFICACIONES-HOY))|#
(define
  (predicado-punsulta1 Notificacion)
  (and(string=? HOY (notificacion-fecha Notificacion))
      (>= (string->number(notificacion-conf Notificacion)) LIMITE-CASOS))
 )

(define
  (localidades-limite-casos notificaciones)
  (map notificacion-loc (filter predicado-punsulta1 notificaciones))
 )
; [Completar, ejercicio 2-2]
(define LOCALIDADES-LIMITE-CASOS (localidades-limite-casos  LISTA-NOTIF))
;;;;;;;;;;;; Consulta 2

; [Completar, ejercicio 3-1]
(define 
  (f lista)
  (cond [(empty? lista) empty]
        [(member? (first lista) (f(rest lista))) (f(rest lista))]
        [else (cons(first lista) (f(rest lista)))]
   )
 )
(define LISTA-DPTO (f LISTA-DPTO-LOC))
; [Completar, ejercicio 3-2]

; [Completar, ejercicio 3-3]

; [Completar, ejercicio 3-4]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Salidas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;; Consulta 1

; [Completar, ejercicio 4 - loc-lim-casos.csv]

;;;;;;; Consulta 2

; [Completar, ejercicio 4 - casos-por-dpto-hoy.csv y casos-por-dpto-antes.csv]