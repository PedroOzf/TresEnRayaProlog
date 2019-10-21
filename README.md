# TresEnRayaProlog
Nuestro codigo consiste en el juego **Tres en Raya** (Three in a row). El juego consiste en una tabla de 3x3 donde dos jugadores, en nuestro caso, un jugador(O) y una inteligencia articial(X), deben colocar sus fichas hasta conseguir poner 3 fichas del mismo tipo en linea.

Las reglas son las siguientes:

<p align="center">
  <ol>
    <li>El tablero esta formado por 3 filas y 3 columnas.</li>
    <li>Cada jugador solo puede colocar una ficha por turno.</li>
    <li>No se puede colocar una ficha en una posicion previamente marcada. </li>
    <li>El ganador sera el primero que consiga tener 3 fichas en una linea recta ya sea horizontal, vertical o diagonal.</li>
    <li>El juego termina cuando gane el jugador(O), la IA(X) o todas las celdas del tablero esten completas, en ese caso se tendra en cuenta como empate.</li>
  </ol>
  <img src="/Img/tablero.jpg" width="300" title="tablero" align="center">
  </p>
  
  Para ejecutar el codigo se necesita el programa [SWI Prolog](https://www.swi-prolog.org/Download.html). Una vez descargardo, en la consola de comandos, nos vamos al directorio donde tenemos el archivo TresEnRaya.pl. 
  
  En Linux ejecutamos los comandos en la consola:
  ~~~
  cd "Directorio del fichero" //Nos situamos en la carpeta donde tenemos el codigo
  swipl TresEnRaya.pl //Para iniciar el programa y cargar el codigo
  jugar(_). //Empezamos la partida
  ~~~
  
Despues de llamar al predicado jugar nos saldra esto por pantalla:
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

##Explicacion del cogido

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
Lo lee y llama al predicado con la tabla vacia y nuestra preferencia partida(Tabla,A) para empezar
 


 
 



