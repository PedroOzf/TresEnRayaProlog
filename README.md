# Tres En Raya en Prolog
Nuestro codigo consiste en el juego **Tres en Raya** (Three in a row). El juego consiste en una tabla de 3x3 donde dos jugadores, en nuestro caso, un jugador(O) y una inteligencia articial(X), deben colocar sus fichas hasta conseguir poner 3 fichas del mismo tipo en linea.

Las reglas son las siguientes:

   1. El tablero esta formado por 3 filas y 3 columnas.
   2. Cada jugador solo puede colocar una ficha por turno.
   3. No se puede colocar una ficha en una posicion previamente marcada.
   4. El ganador sera el primero que consiga tener 3 fichas en una linea recta ya sea horizontal, vertical o diagonal.
   5. El juego termina cuando gane el jugador(O), la IA(X) o todas las celdas del tablero esten completas, en ese caso se tendra en cuenta como empate.
    
  <p align="center">
  <img src="/Img/tablero.jpg" width="300" title="tablero" align="center">
  </p>
  
  Para ejecutar el código se necesita el programa [SWI Prolog](https://www.swi-prolog.org/Download.html). Una vez descargardo, en la consola de comandos, nos vamos al directorio donde tenemos el archivo TresEnRaya.pl. 
  
  En Linux ejecutamos los comandos en la consola:
  ~~~
  cd "Directorio del fichero" //Nos situamos en la carpeta donde tenemos el codigo
  swipl TresEnRaya.pl //Para iniciar el programa y cargar el codigo
  jugar(_). //Empezamos la partida
  ~~~
  
Después de llamar al predicado jugar nos saldrá esto por pantalla:
~~~
?- jugar(_).
   |a|b|c|
 1 | | | |
 2 | | | |
 3 | | | |
Escoje Turno: (1-Empieza IA; 0-Empieza Jugador
|: 0.
~~~
  Una vez ejecutado, el primer turno por defecto sera el del Jugador. Se le preguntara en que posicion desea marcar. Primero la fila (1,2 o 3) y despues la columna a, b o c.
  

~~~
Turno jugador: 
Fila: 
|: 2.

Columna: 
|: b.

   |a|b|c|
 1 | | | |
 2 | |X| |
 3 | | | |
Turno IA: 
   |a|b|c|
 1 | | | |
 2 | |X| |
 3 | | |O|
~~~	

La IA esta implementada para empatar o ganar pero nunca perder independientemente de si empieza la partida o no. Si cometes un error la maquina lo aprovecha para ganarte. Un ejemplo claro:
~~~
Turno jugador: 
Fila: 
|: 1.

Columna: 
|: c.

   |a|b|c|
 1 |X| |X|
 2 | |X| |
 3 |O| |O|
Turno IA: 
   |a|b|c|
 1 |X| |X|
 2 | |X| |
 3 |O|O|O|
Fin de partida, gana O

~~~

## Explicación del código

El predicado para iniciar la partida consta de las siguientes partes: 
 ~~~
jugar(_):-
	iniciar_tablero(Tabla),
	show(Tabla),
	write("Escoje Turno: (1-Empieza IA; 0-Empieza Jugador"),
	nl,
	read(A),
	partida(Tabla,A).
 ~~~
 
 Hemos representado el tablero como una lista de 9 posiciones. Al empezar la partida establecemos todas esas posiciones a "n" para referirse a que no hay nada.
 
 ~~~
 iniciar_tablero([n,n,n,n,n,n,n,n,n]).
 ~~~
 Le devueve esta lista vacia al predicado show() donde imprime la lista que reciba:
 
 ~~~
 show(Tabla):-
	write('   |a|b|c|'),
	nl,
	write(' 1 |'),
	showValue(Tabla,1),
	write('|'),
	showValue(Tabla,2),
	write('|'),
	showValue(Tabla,3),
	write('|'),
	nl,
	write(' 2 |'),
	showValue(Tabla,4),
	write('|'),
	showValue(Tabla,5),
	write('|'),
	showValue(Tabla,6),
	write('|'),
	nl,
	write(' 3 |'),
	showValue(Tabla,7),
	write('|'),
	showValue(Tabla,8),
	write('|'),
	showValue(Tabla,9),
	write('|'),
	nl.
~~~
Divide la lista que le enviamos en 3 lineas para asi representar una matriz de 3x3, es decir, el tablero del 3 en raya.
showValue detecta si hay una "n","x" u "o" en la lista y devuelve el valor asignado para cada uno. En este caso, como todo esta a "n" devuelve un ' '.
El resultado seria este porque la lista esta vacia: 
~~~
?- jugar(_).
   |a|b|c|
 1 | | | |
 2 | | | |
 3 | | | |
 ~~~
 
 Despues de imprimir el tablero vacio por pantalla te pregunta quien quieres que empieze la partida, si el jugador o la IA.
 
 ~~~
 Escoje Turno: (1-Empieza IA; 0-Empieza Jugador
|: 
~~~
Lo lee y llama al predicado con la tabla vacia y nuestra preferencia partida(Tabla,A) para empezar la partida.
 
En funcion del valor de A ( nuestra eleccion de jugador) llama a un predicado o a otro: 

~~~
partida(Tabla,1):-
	write('Turno IA: '),
	nl,
	gallego(Tabla, NuevaTabla,o),
	show(NuevaTabla),
	\+ victoria(NuevaTabla,o),
	\+ empate(NuevaTabla),
	partida(NuevaTabla,0),
	!.
partida(Tabla,0):-
	write('Turno jugador: '),
	nl,
	jugador(Tabla, T,x),
	show(T),
	\+ victoria(T,x),
	\+ empate(T),
	partida(T,1),
	!.
~~~	

## Empieza el jugador

Si la opcion fue que empieza primero el jugador, se llamara a jugador(Tabla, Nueva Tabla, x). Donde le pasamos la tabla y la ficha del jugador que son las 'x'. Y este nos devuelve una tabla nueva con la posicion actualizada.

~~~
jugador(Tabla,NuevaTabla, Jugador):-
	write('Fila: '),
	nl,
	read(F),
	nl,
	write('Columna: '),
	nl,
	read(C),
	nl,
	obtener_posicion(F,C,P),
	movimiento(Tabla,P,NuevaTabla,Jugador).
~~~
Lee la fila y columna que escribimos. La situa en la matriz y la actualiza.
movimiento() se asegura de que la celda donde queremos colocar la ficha no esta ocupada por otra.

Despues muestra la matriz actualizada por pantalla.
~~~
Turno jugador: 
Fila: 
|: 2.

Columna: 
|: a.

   |a|b|c|
 1 | | | |
 2 |X| | |
 3 | | | |
 ~~~
 
 Antes de acabar el turno comprueba que:
 <ol>
    <li>Todavia quedan celdas por marcar, osea que no hay empate</li>
    <li>Comprueba si el jugador con las 'X' ha conseguido colocar 3 fichas en linea.</li>
 </ol>
 
La forma que tiene para comprobar si el jugador a ganado es la siguiente:
Tenemos todas las variantes de victoria. 3 lineas horizontales, 3 lineas verticales y otra 2 en diagonal:

~~~
jugada_ganada([F,F,F,_,_,_,_,_,_],F).
jugada_ganada([_,_,_,F,F,F,_,_,_],F).
jugada_ganada([_,_,_,_,_,_,F,F,F],F).
jugada_ganada([F,_,_,F,_,_,F,_,_],F).
jugada_ganada([_,F,_,_,F,_,_,F,_],F).
jugada_ganada([_,_,F,_,_,F,_,_,F],F).
jugada_ganada([F,_,_,_,F,_,_,_,F],F).
jugada_ganada([_,_,F,_,F,_,F,_,_],F).
~~~
Si alguna de esas jugadas resulta ser true, significaria que el jugador que acaba de mover ha ganado la partida:
~~~
victoria(Tablero,Jugador):-
	jugada_ganada(Tablero,Jugador),
	write('Fin de partida, gana '),
	showPlayer(Jugador),
	nl,
	!.
~~~

Por ejemplo si la IA ganase (las 'O'), se imprimiria esto por pantalla:
~~~
Turno IA: 
   |a|b|c|
 1 |X|X|O|
 2 |X|O| |
 3 |O| | |
Fin de partida, gana O
~~~
La lista de esta partida seria:
**[X,X,O,X,O, ,O, , ]**
Vemos que la IA tiene en la diagonal, es decir, que al comprobar con jugada_ganada() devolvera **true** ya que:

~~~
jugada_ganada([_,_,F,_,F,_,F,_,_],F).
~~~
Donde F es igual a O.

## Empieza la IA
En el otro caso, que elegimos que empiece la IA. En vez de llamar al predicado jugador() llama al predicado:
~~~
partida(Tabla,1):-
	write('Turno IA: '),
	nl,
	gallego(Tabla, NuevaTabla,o),
	show(NuevaTabla),
	\+ victoria(NuevaTabla,o),
	\+ empate(NuevaTabla),
	partida(NuevaTabla,0),
	!. 
~~~

En ese predicado le mandamos la tabla actual y que el jugador actual es el que usa 'O' (La IA).
~~~
gallego(Tabla,NuevaTabla,Jugador):-
	prueba1(Tabla,1,Jugador,Pos),
	movimiento(Tabla,Pos,NuevaTabla,Jugador),!;
	other(Jugador,J),
	prueba1(Tabla,1,J,Pos),
	movimiento(Tabla,Pos,NuevaTabla,Jugador),!;
	comprobarCuenta(Tabla,Jugador,Pos),
	movimiento(Tabla,Pos,NuevaTabla,Jugador),!.
~~~	
Lo primero que hara sera consultar con el predicado prueba1 enviandole la tabla actual, un contador para el numero de simulaciones y el jugador. Esperando que devuelva una posicion.

~~~
prueba1(Tabla,Count,Jugador,Pos):-
	movimiento(Tabla,Count,NuevaTabla,Jugador),
	jugada_ganada_pos(NuevaTabla,Jugador,Count,Pos),!;
	Count1 is Count + 1,
	Count1<10,
	prueba1(Tabla,Count1,Jugador,Pos).
~~~	



