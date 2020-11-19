# En esta implementación del juego, se tomaron ciertas decisiones sobre las estructuras de datos a usar y el diseño. Se hace
# entonces una descripción general de los puntos más relevantes.
#
# * El programa tambien pide que se ingresen:
# - La ruta a un archivo que se supone no este vacío y tenga una palabra por línea. Dicho archivo sera parseado como una lista
#   de strings ('diccionario')
# - El nombre del jugador guardado internamente como un String ('nombreJugador') 
# - La ruta a un archivo que se supone tenga como lineas posibles, uno nombre o una palabra en minusculas, SI/NO, un número.
#   Dicho archivo sera parseado com un diccionario sindo las claves los nombres  y como datos Listas(Listas(String)).
#
# * La palabra a adivinar es seleccionada en forma aleatoria de una lista predefinida de palabras posibles ('diccionario').
#   letras de dicha palabra pertenezca al abededario.
#
# * La palabra a adivinar es guardada internamente como un String ('palabraSecreta').
#
# * La palabra que se va completando a medida que el jugador va sugiriendo letras, es representada como 
#   un String ('palabraAdivinada'), de igual longitud que la palabra a adivinar. Este String es inicialmente una secuencia de 
#   '-', uno por cada letra de la palabra a adivinar. A medida que se van sugiriendo letras que están en la palabra a adivinar, 
#   los '-' son sustituidos por dichas letras.
#	
# * El programa guarda en un String ('letrasYaJugadas'), las letras que va sugiriendo el jugador. Así, utilizando este String, 
#   cuando el jugador ingresa una nueva letra, el programa verificará que se trate de una letra del abecedario que no haya sido 
#   ya sugerida. En el caso en que lo ingresado no sea una letra o sea una letra repetida, el programa dará un mensaje de error 
#   pero no descontará una vida, simplemente volverá a solicitar una nueva letra.
#
# * Cuando el jugador ingresa una letra que está en el abecedario y no está repetida, el programa evalúa si la letra es un substring
#   de la palabra a adivinar ('palabraSecreta'). Si no lo es, descontará una vida. Si lo es, recorrerá la palabra a adivinar
#   para determinar en qué posiciones está la letra. Cuando la encuentra en una cierta posición, sustituye en 
#   la palabra oculta ('palabraAdivinada') el '-' por dicha letra.
#
# * Para controlar los posibles errores en los ingresos de los jugadores, el programa verifica que cuando se espera una letra, 
#	la cadena ingresada tenga longitud 1 y sea un substring del abecedario. Y en el caso de que lo esperado sea una palabra, 
#	el programa verifica que cada caracter de la cadena sea un substring del abecedario.
#


import os #usamos path y remove
from random import randrange
import sys

#--------------------------------------------------
# inicializarAlfabeto: None -> String
# Descripción: Devuelve el alfabeto con el que se va a jugar.

def inicializarAlfabeto():
    return 'abcdefghijklmnñopqrstuvwxyz'
#Función de prueba de la función inicializarAlfabeto
def test_inicializarAlfabeto():   
    assert inicializarAlfabeto()== 'abcdefghijklmnñopqrstuvwxyz'
#--------------------------------------------------
# inicializarPalabraAdivinada: Int -> String
# Descripción: recibe la longitud de la palabra a adivinar y devuele un String de '-' consecutivos, 
# de la misma longitud que la palabra.

def inicializarPalabraAdivinada(tamanio):
    return '-' * tamanio
#Función de prueba de la función inicializarPalabraAdivinada
def test_inicializarPalabraAdivinada():
    assert inicializarPalabraAdivinada(3)=='---'
    assert inicializarPalabraAdivinada(0)==''

#--------------------------------------------------
# chequearPalabra: String String -> Bool
# Descripción: esta función recibe una palabra y un abecesario, y determina si todos las letras de la palabra pertenecen
# al abecedario. Para esto recorre la palabra letra por letra determinando si éstas están en el abecedario.

def chequearPalabra(palabra,alfabeto):
    posicion = 0
    palabra=palabra.lower()
    cantidadLetras = len(palabra)
    while posicion < cantidadLetras  and palabra[posicion] in alfabeto:
        posicion += 1
    return (posicion == cantidadLetras)
#Función de prueba de la función chequearPalabra
def test_chequearPalabra():
    assert chequearPalabra('aaabbc','abc')== True
    assert chequearPalabra('aaabbC','abc')== True
    assert chequearPalabra('aaabbcd','abc')== False
#--------------------------------------------------
# chequearLetra: String String String -> Bool
# Descripción: esta función verifica que una cadena sea una letra, que esté en el abcedario y no haya sido previamente ingresada. 
# Si no es un caracter, no está en el alfabeto o ya fue ingresada, dará un mensaje de error y devolverá False. En caso contrario, 
# devolverá True.

def chequearLetra(letra,alfabeto,yaJugadas):
    chequeo = True
    if (letra == ''):
        print('Error - No ingreso ningún caracter')
        chequeo = False
    elif (len(letra)>1): # Si no es un caracter, dará un error.
        print('Error - Ingreso más de un caracter')
        chequeo = False
    elif (letra not in alfabeto): # Si es un caracter pero no está en el abecedario, dará un error.
        print('Error - Ingreso un caracter invalido')
        chequeo = False
    elif (letra in yaJugadas): # Si es un caracter que está en el abecedario y pero ya fue ingresado, dará un error.
        print('Error - Letra ya jugada')
        chequeo = False
    return chequeo # Si nada de lo anterior se cumple, es un caracter válido y devuelve True.
    
#Función de prueba de la función chequearLetra
def test_chequearLetra():
    assert chequearLetra('ab','abc','')==False
    assert chequearLetra('a','abc','')==True
    assert chequearLetra('a','abc','a')==False
    assert chequearLetra('g','abc','')==False
#--------------------------------------------------
# ingresarLetra: String String -> Char
# Descripción: esta función recibe un alfabeto y las letras ya ingresadas por el jugador, y solicita a éste que ingrese una 
# nueva letra sugerida. Mientras el jugador no ingrese una letra que esté en el alfabeto y no haya sido ingresada previamente,
# la función seguirá pidiendo el ingreso de una nueva letra. Cuando la letra ingresada sea válida, la función la devolverá 
# en minúscula, independientemente de cómo la haya ingresado el jugador.

def ingresarLetra(alfabeto,letrasYaJugadas):
    letra = input('Ingrese una letra: ')
    letra = letra.lower()
    while(not chequearLetra(letra,alfabeto,letrasYaJugadas)): # Mientras no sea una letra válida, pedir una letra.
        letra=input('Vuelva a ingresar una letra: ')
        letra=letra.lower()
    return letra
  
#--------------------------------------------------
# ingresarNombreJugador: String -> String
# Descripción: esta función recibe el alfabeto que se va a utilizar y solicita al segundo jugador que ingrese su nombre. Usando
# el alfabeto, determinará si la nombre ingresado está construida con dicho alfabeto y es una palabra válida. En caso de no serlo, 
# dará un mensaje de error y seguirá solicitando un nombre hasta que sea válido. Cuando esto ocurra, devolverá el nombre capitalizado, 
# independientemente de cómo haya sido ingresado.

def ingresarNombreJugador(alfabeto):
    nombre = input('Jugador 2, por favor, ingrese su nombre\n')    
    while(not chequearPalabra(nombre.lower(),alfabeto)): # Mientras la palabra no sea válida, pedir una palabra a adivinar.
        print('ERROR - La palabra ingresada contiene caracteres no validos')
        nombre = input('Jugador 2, por favor, ingrese su nombre\n')
    return nombre.capitalize()

# ingresarRutaDiccionario: String Boolean -> String
# Descripción: esta función recibe el alias del archivo objetivo, si se quiere crear el archivo y devuelve la ruta al archivo. 
# Si la ruta no corresponde a un archivo y no se desea crear el archivo, dara un error y seguira solicitando una ruta hasta
# que sea valida. En caso de que se quiera crear un archivo, la funcion crea el archivo en la ruta recibida.

def ingresarRuta(objetivo, crear_archivo=False):
    ruta = input('Por favor, ingrese la ruta al %s\n' % objetivo)
    while not os.path.isfile(ruta):
        if crear_archivo and not os.path.isdir(ruta):
            archivo=open(ruta, 'w')
            archivo.close()
        elif crear_archivo:
            print('ERROR - La ruta ingresada es un directorio')
            ruta = input('Por favor, ingrese la ruta al %s\n' % objetivo)
        else:
            print('ERROR - La ruta ingresada no corresponde a un archivo')
            ruta = input('Por favor, ingrese la ruta al %s\n' % objetivo)
    return ruta

#--------------------------------------------------
# rutaDiccionarioToLista: String -> List
# Descripción: esta función recibe la ruta al diccionario y devuelve la lista de palabra en el archivo.

def rutaDiccionarioToLista(rutaDiccionario):
    listaPalabras = []
    with open(rutaDiccionario) as diccionario:
        for linea in diccionario:
            palabra = linea.split()[0]
            listaPalabras.append(palabra)
    return listaPalabras
#Función de prueba de la función rutaDiccionarioToLista
def test_rutaDiccionarioToLista():
    rutaDiccionario ='prueba,txt'
    with open(rutaDiccionario,'w') as archivo:
        archivo.write('linea\nlinea')
    assert rutaDiccionarioToLista(rutaDiccionario)==['linea','linea']
    os.remove(rutaDiccionario)
    rutaDiccionario ='prueba,txt'
    with open(rutaDiccionario,'w') as archivo:
        archivo.write('')
    assert rutaDiccionarioToLista(rutaDiccionario)==[]
    os.remove(rutaDiccionario)

#--------------------------------------------------
# rutaHistorialToMapa: String -> Dictionary
# Descripción: esta función recibe la ruta al historial y devuelve un diccionario conteniendo el historial de
# partidas

def rutaHistorialToMapa(rutaHistorial):
    mapa = {}
    with open(rutaHistorial) as historial:
        nombreActual = '' 
        for linea in historial:
            linea = linea.strip()
            if linea == '':
                continue            
            if linea[0].isupper():
                nombreActual = linea
                mapa[nombreActual] = []
            else:
                jugada = linea.split(',')
                mapa[nombreActual].append(jugada)
    return mapa
#Función de prueba de la función rutaHistorialToMapa
def test_rutaHistorialToMapa():
    rutaHistorial ='prueba,txt'
    with open(rutaHistorial,'w') as archivo:
        archivo.write('Juan\n hola,SI,6\n como,NO,4\n Gas\n gato,NO,10')
    assert rutaHistorialToMapa(rutaHistorial)=={'Juan': [['hola', 'SI','6'],['como','NO','4']], 'Gas': [['gato','NO','10']]}
    os.remove(rutaHistorial)
    rutaHistorial ='prueba,txt'
    with open(rutaHistorial,'w') as archivo:
        archivo.write('')
    assert rutaHistorialToMapa(rutaHistorial)=={}
    os.remove(rutaHistorial)
#--------------------------------------------------
# obtenerPalabrasJugadas: Dictionary String -> List
# Descripción: oesta función recibe el historial de partidas y el nombre del jugador y devuelve las palabras que
# ya jugó el jugador.

def obtenerPalabrasJugadas(historial, nombre):
    palabrasJugadas = []
    if nombre in historial:
        jugadas = historial[nombre]
        palabrasJugadas = [jugada[0] for jugada in jugadas]
    return palabrasJugadas
#Función de prueba de la función obtenerPalabrasJugadas
def test_obtenerPalabrasJugadas():
    historial= {'Juan': [['hola', 'SI','6'],['como','NO','4']], 'Gas': [['gato','NO','10']]}
    assert obtenerPalabrasJugadas(historial, 'Juan')==['hola','como']
    assert obtenerPalabrasJugadas(historial, 'Gas')==['gato']
    assert obtenerPalabrasJugadas(historial, 'Vero')==[]
    assert obtenerPalabrasJugadas({}, 'Vero')==[]
#--------------------------------------------------
# obtenerPalabraSecreta: List(String) List(String) -> String
# Descipción: esta función recibe el diccionario y las palabras ya jugadas y devuelve la palabra secreta. La 
# palabra secreta se elige al azar de entre las palabras no jugadas, siempre que esto sea posible.

def obtenerPalabraSecreta(diccionario, palabrasJugadas):
    if len(palabrasJugadas)>= len(diccionario):
        return  diccionario[randrange(len(diccionario))]
    palabrasNoJugadas = [palabra for palabra in diccionario if palabra not in palabrasJugadas]
    return palabrasNoJugadas[randrange(len(palabrasNoJugadas))]
#Función de prueba de la función
def test_obtenerPalabraSecreta():
    diccionario = ['uno','dos']
    palabrasJugadas=['uno']
    assert obtenerPalabraSecreta(diccionario, palabrasJugadas)=='dos'
    diccionario = ['uno','dos']
    palabrasJugadas=[]
    assert obtenerPalabraSecreta(diccionario, palabrasJugadas) in diccionario
    diccionario = ['uno','dos']
    palabrasJugadas=['uno','dos']
    assert obtenerPalabraSecreta(diccionario, palabrasJugadas) in diccionario

#--------------------------------------------------
# actualizarHistorial: Dictionary String String Boolean Int -> Dictionary
# Descripción: esta función recibe el historial de partidas, la palabra secreta, si gano o no el jugador y la
# cantidad de jugadas y devuelve el historial actualizado.

def actualizarHistorial(historial, nombreJugador, palabraSecreta, gano, cantidadJugadas):
    resultado = [palabraSecreta, 'SI' if gano else 'NO', str(cantidadJugadas)]
    if nombreJugador in historial:
        historial[nombreJugador] += [resultado]
    else:
        historial[nombreJugador] = [resultado]
    return historial
#Función de prueba de la función actualizarHistorial
def test_actualizarHistorial():
    historial= {'Juan': [['hola', 'SI','6'],['como','NO','4']], 'Gas': [['gato','NO','10']]}
    assert actualizarHistorial(historial,'Vero','patata',True,6)=={'Juan': [['hola', 'SI','6'],['como','NO','4']], 'Gas': [['gato','NO','10']], 'Vero':[['patata','SI','6']]}
    historial={}
    assert actualizarHistorial(historial,'Vero','patata',True,6)=={'Vero':[['patata','SI','6']]}
#--------------------------------------------------
# escribirHistorial: String Dictionary -> None
# Descripción: esta función toma la ruta al historial, el historial actualizado y escribe el historial
# en la ruta

def escribirHistorial(rutaHistorial, historial):
    with open(rutaHistorial, 'w') as archivoHistorial:
        for nombre in historial:
            archivoHistorial.write(nombre + '\n')
            for jugada in historial[nombre]:
                archivoHistorial.write(','.join(jugada) + '\n')

#--------------------------------------------------
# jugar: None -> None
# Descripción: esta es la función principal, la cual inicia y lleva adelante el juego hasta el final.

def jugar():
    print('Bienvenido al juego del Ahorcado')
    alfabeto = inicializarAlfabeto()	# Obtiener el alfabeto que se va a utilizar (alfabeto:String).
    letrasYaJugadas = ''				# Guardar las letras propuestas por el jugador.
    gano = False						# Identificador de si el jugador ha ganado o no.
    vidas = 6							# 'vidas' guarda la cantidad de vidas que tiene el jugador para adivinar la palabra.
    
    rutaDiccionario = ingresarRuta('diccionario') # Solicitar la ruta al archivo que contiene el diccionario de palabra validas.
    rutaHistorial = ingresarRuta('historial de partidas', True) # Solicitar la ruta al archivo que contiene el historial de partidas.
    diccionario = rutaDiccionarioToLista(rutaDiccionario) # Leer la lista de palabras validas desde la ruta
    historial = rutaHistorialToMapa(rutaHistorial) # Leer el historial de partidas desde la ruta

    nombreJugador = ingresarNombreJugador(alfabeto) # Solicitar que se ingrese el nombre del segundo jugador (nombreJugador: String).
    palabrasJugadas = obtenerPalabrasJugadas(historial, nombreJugador) # Obtener las palabras jugadas por el segundo jugador.
    palabraSecreta = obtenerPalabraSecreta(diccionario, palabrasJugadas) # Solicitar que se ingrese la palabra a adivinar (palabraSecreta:String).
    palabraAdivinada = inicializarPalabraAdivinada(len(palabraSecreta)) # Generar la secuencia de '-' que representa la palabra 
																		# oculta (palabraAdivinada: String)

    print(nombreJugador, ' es hora de adivinar!')
    while(vidas > 0 and not palabraSecreta==palabraAdivinada):	# Mientras haya vidas y la palabra oculta sea diferente de la 
																# palabra a adivinar, seguir jugando.
        print('Juegue: ')
        print('Palabra Secreta:\n', palabraAdivinada)			# Mostrar la palabra oculta.
        letra = ingresarLetra(alfabeto,letrasYaJugadas)			# Solicitar al jugador que ingrese una letra.
        letrasYaJugadas=letrasYaJugadas+letra					# Guardar la letra ingresada.
        if(letra not in palabraSecreta):						# Si la letra no está en la palabra a adivinar, se restará una vida.
            vidas -=1
        else:											# Si la letra está en la palabra a adivinar,
            for x in range(0,len(palabraSecreta)):		# recorrer esta última para saber en qué posiciones la letra aparece.
                if(palabraSecreta[x]==letra):			# En dichar posiciones, sustituye '-' en la palabra oculta por la letra.
                    palabraAdivinada= palabraAdivinada[:x]+letra+palabraAdivinada[x+1:]
                    
	# Al salir del bucle, se pregunta la causa de la salida, para dar diferentes mensajes al jugador.	                    
    if(palabraSecreta==palabraAdivinada):	# La palabra fue adivinada. El jugador ganó.
        print('Felicitaciones! Adivino la palabra secreta: ', palabraSecreta)
        gano = True
    else:			# Se acabaron las vidas. El jugador perdió.
        print('Ud. ha perdido - La palabra secreta era: ', palabraSecreta)        

    historial = actualizarHistorial(historial, nombreJugador, palabraSecreta, gano, len(letrasYaJugadas))
    escribirHistorial(rutaHistorial, historial)
            

#--------------------------------------------------	
# correrTests: None -> None
# Descripción: esta es la función que llama a los test para chequear que este todo funcionando.
def correrTests():
    stdout = sys.stdout # guardamos stdout
    sys.stdout = None # evitamos que cualquier mensaje de los tests se imprima
    test_inicializarAlfabeto()
    test_inicializarPalabraAdivinada()
    test_chequearPalabra()
    test_chequearLetra()
    test_obtenerPalabraSecreta()
    test_rutaDiccionarioToLista()
    test_rutaHistorialToMapa()
    test_obtenerPalabrasJugadas()
    test_actualizarHistorial()
    sys.stdout = stdout
    
#--------------------------------------------------	
#Iniciar el juego.
correrTests()
jugar()
