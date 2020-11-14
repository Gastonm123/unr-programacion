from os import path

#--------------------------------------------------
# inicializarAlfabeto: None -> String
# Descripción: Devuelve el alfabeto con el que se va a jugar.

def inicializarAlfabeto():
    return 'abcdefghijklmnñopqrstuvwxyz'
    
    
#--------------------------------------------------
# inicializarPalabraAdivinada: Int -> String
# Descripción: recibe la longitud de la palabra a adivinar y devuele un String de '-' consecutivos, 
# de la misma longitud que la palabra.

def inicializarPalabraAdivinada(tamanio):
    return '-' * tamanio


#--------------------------------------------------
# chequearPalabra: String String -> Bool
# Descripción: esta función recibe una palabra y un abecesario, y determina si todos las letras de la palabra pertenecen
# al abecedario. Para esto recorre la palabra letra por letra determinando si éstas están en el abecedario.

def chequearPalabra(palabra,alfabeto):
    posicion = 0
    cantidadLetras = len(palabra)
    while posicion < cantidadLetras  and palabra[posicion] in alfabeto:
        posicion += 1
    return (posicion == cantidadLetras)

#--------------------------------------------------
# ingresarPalabra: String -> String
# Descripción: esta función recibe el alfabeto que se va a utilizar y solicita al jugador que ingrese la palabra a adivinar. Usando
# el alfabeto, determinará si la palabra ingresada está construida con dicho alfabeto y es una palabra válida. En caso de no serlo, 
# dará un mensaje de error y seguirá solicitando una palabra hasta que la ingresada sea válida. Cuando esto ocurra, devolverá la
# palabra válida en minúscula, independientemente de cómo haya sido ingresada.

def ingresarPalabra(alfabeto):
    palabra = input('Jugador 1, por favor, ingrese la palabra secreta\n')
    palabra = palabra.lower()
    while(not chequearPalabra(palabra,alfabeto)):	# Mientras la palabra no sea válida, pedir una palabra a adivinar.
        print('ERROR - La palabra ingresada contiene caracteres no validos')
        palabra = input('Jugador 1, por favor, ingrese la palabra secreta')
        palabra = palabra.lower()
    return palabra



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
    if (len(letra)>1):	# Si no es un caracter, dará un error.
        print('Error - Ingreso mas de un caracter')
        chequeo = False
    elif (letra not in alfabeto): # Si es un caracter pero no está en el abecedario, dará un error.
        print('Error - Ingreso un caracter invalido')
        chequeo = False
    elif (letra in yaJugadas): # Si es un caracter que está en el abecedario y pero ya fue ingresado, dará un error.
        print('Error - Letra ya jugada')
        chequeo = False
    return chequeo # Si nada de lo anterior se cumple, es un caracter válido y devuelve True.
    

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
    ruta = input('Jugador 1, por favor, ingrese la ruta al %s\n' % objetivo)
    while not path.isfile(ruta):
        if crear_archivo and not path.isdir(ruta):
            with open(ruta, 'w') as archivo:
                pass
        elif crear_archivo:
            print('ERROR - La ruta ingresada es un directorio')
            ruta = input('Jugador 1, por favor, ingrese la ruta al %s\n' % objetivo)
        else:
            print('ERROR - La ruta ingresada no corresponde a un archivo')
            ruta = input('Jugador 1, por favor, ingrese la ruta al %s\n' % objetivo)
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
    historial = rutaHistorialToDiccionario(rutaHistorial) # Leer el historial de partidas desde la ruta
    palabraSecreta = ingresarPalabra(alfabeto, diccionario)	# Solicitar que se ingrese la palabra a adivinar (palabraSecreta:String).
    palabraAdivinada = inicializarPalabraAdivinada(len(palabraSecreta)) # Generar la secuencia de '-' que representa la palabra 
																		# oculta (palabraAdivinada: String)

    nombreJugador = ingresarNombreJugador(alfabeto) # Solicitar que se ingrese el nombre del segundo jugador (nombreJugador: String)

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
    else:			# Se acabaron las vidas. El jugador perdió.
        print('Ud. ha perdido - La palabra secreta era: ', palabraSecreta)
            

#--------------------------------------------------	
#Iniciar el juego.
jugar()
