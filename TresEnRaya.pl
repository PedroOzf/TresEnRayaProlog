/**
Tres en Raya prolog
    Copyright (C) 2019  Miguel Pazos, Pedro Ortiz

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
iniciar_tablero([n,n,n,n,n,n,n,n,n]).
jugada_ganada([F,F,F,_,_,_,_,_,_],F).
jugada_ganada([_,_,_,F,F,F,_,_,_],F).
jugada_ganada([_,_,_,_,_,_,F,F,F],F).
jugada_ganada([F,_,_,F,_,_,F,_,_],F).
jugada_ganada([_,F,_,_,F,_,_,F,_],F).
jugada_ganada([_,_,F,_,_,F,_,_,F],F).
jugada_ganada([F,_,_,_,F,_,_,_,F],F).
jugada_ganada([_,_,F,_,F,_,F,_,_],F).
showPlayer(x):-
	write('X').
showPlayer(o):-
	write('O').
showPlayer(n):-
	write(' ').
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
showValue(Tabla,Pos):-
	nth1(Pos,Tabla,Val),
	showPlayer(Val).
victoria(Tablero,Jugador):-
	jugada_ganada(Tablero,Jugador),
	write('Fin de partida, gana '),
	showPlayer(Jugador),
	nl,
	!.
jugar(_):-
	iniciar_tablero(Tabla),
	show(Tabla),
	write("Escoje Turno: (1-Empieza IA; 0-Empieza Jugador"),
	nl,
	read(A),
	partida(Tabla,A).
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
gallego(Tabla,NuevaTabla,Jugador):-
	prueba1(Tabla,1,Jugador,Pos),
	movimiento(Tabla,Pos,NuevaTabla,Jugador),!;
	other(Jugador,J),
	prueba1(Tabla,1,J,Pos),
	movimiento(Tabla,Pos,NuevaTabla,Jugador),!;
	comprobarCuenta(Tabla,Jugador,Pos),
	movimiento(Tabla,Pos,NuevaTabla,Jugador),!.
other(x,o).
other(o,x).
empate([P1,P2,P3,P4,P5,P6,P7,P8,P9]):-
	\+ nada(P1),
	\+ nada(P2),
	\+ nada(P3),
	\+ nada(P4),
	\+ nada(P5),
	\+ nada(P6),
	\+ nada(P7),
	\+ nada(P8),
	\+ nada(P9).
nada(n).
%GenerarJugada
vaciar(Tabla,NuevaTabla,J,Pos):-
	Pos<10,
	nth1(Pos,Tabla,Val),
	\+ Val = J,
	Pos1 is Pos+1,
	vaciar(Tabla,NuevaTabla,J,Pos1),!.
vaciar(Tabla,Tabla,_,Pos):-
	Pos>9,
	!.
vaciar(Tabla,NuevaTabla,J,Pos):-
	Pos<10,
	nth1(Pos,Tabla,Val),
	Val = J,
	insert(Tabla,Pos,n,NuevaTabla1),
	Pos1 is Pos+1,
	vaciar(NuevaTabla1,NuevaTabla,J,Pos1),!.
countLines(Tabla,Jugador,Pos,Count):-
	vaciar(Tabla,Nueva,Jugador,1),
	counter(Nueva,Jugador,Pos,Count).
calculeVictory(Tabla,Jugador,Pos,Res):-
	countLines(Tabla,Jugador,Pos,Vic),
	movimiento(Tabla,Pos,NuevaTabla,Jugador),
	other(Jugador,J),
	otherCount(NuevaTabla,J,Der),
	Res is Vic-Der.
counter(Tabla,Jugador,Pos,Count):-
	findall(1,jugada_ganada(Tabla,n),R),
	length(R,Vic),
	movimiento(Tabla,Pos,NuevaTabla,Jugador),
	findall(1,jugada_ganada(NuevaTabla,n),Res1),
	length(Res1,Fail),
	Count is Vic-Fail,!.
ia(Tabla,Jugador,Pos,Count,Win):-
	Pos<10,
	\+ calculeVictory(Tabla,Jugador,Pos,Count),
	Pos1 is Pos+1,
	ia(Tabla,Jugador,Pos1,Count,Win),!.
ia(_,_,Pos,-10,9):-
	Pos>9,!.
prueba1(Tabla,Count,Jugador,Pos):-
	movimiento(Tabla,Count,NuevaTabla,Jugador),
	jugada_ganada_pos(NuevaTabla,Jugador,Count,Pos),!;
	Count1 is Count + 1,
	Count1<10,
	prueba1(Tabla,Count1,Jugador,Pos).
ia(Tabla,Jugador,Pos,Count,Win):-
	Pos<10,
	calculeVictory(Tabla,Jugador,Pos,Count1),
	Pos1 is Pos+1,
	ia(Tabla,Jugador,Pos1,Count2,Win2),
	(Count2<Count1,
	Win is Pos,
	Count is Count1;
	Win is Win2,
	Count is Count2),!.
otherCount(Tabla,Jugador,Count):-
	vaciar(Tabla,Nueva,Jugador,1),
	count(Nueva,n,Count).
count(Tabla,Jugador,Count):-
	findall(1,jugada_ganada(Tabla,Jugador),R),
	length(R,Count).
comprobarCuenta(Tabla, Jugador,Pos):-
	ia(Tabla,Jugador,1,_,Pos).
jugada_ganada_pos(Tabla,Jugador,Count,Pos):-
	jugada_ganada(Tabla,Jugador),
	Pos is Count,!.
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

movimiento(Tabla,Pos,NuevaTabla,Jugador):-
	es_vacio(Tabla,Pos),
	insert(Tabla,Pos,Jugador,NuevaTabla).

insert([_|T],1,E,[E|T]).
insert([H|T],P,E,[H|R]) :-
    P > 1, NP is P-1, insert(T,NP,E,R).
es_vacio(Tabla,Pos):-
	nth1(Pos,Tabla,Val),
	Val='n'.
obtener_posicion(1,a,1).
obtener_posicion(1,b,2).
obtener_posicion(1,c,3).
obtener_posicion(2,a,4).
obtener_posicion(2,b,5).
obtener_posicion(2,c,6).
obtener_posicion(3,a,7).
obtener_posicion(3,b,8).
obtener_posicion(3,c,9).
