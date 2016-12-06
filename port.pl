:- include('config.pl').
:- include('util.pl').

:- use_module(library(lists)).

:- 	dynamic
	port/1.
	
port(_).

port_init:- 

		write('Loading Port Configurations...'), nl, nl,
		
		%retrieving config and display
		port_lines(Lines),
		port_columns(Columnns),
		container_types(Types),	
		display_config(Lines, Columnns, Types),
		
		%creating port and display
		create_port(Lines, Columnns),	
		display_port_by_length,
		
		%start cycle to create boats with containers
		start_cycle(Types, Lines, Columnns).
		

%=========================================================================

start_cycle(Types, Lines, Columnns):-	

		%get any input
		get_str,
		
		%generate boat with containers
		generate_boat(Types, Lines, Columnns, Boat),
		
		%solve to port		
		solve(Boat),
		display_port_by_length,
		
		%expedition

		%assert new times
		
		start_cycle(Types, Lines, Columnns).
		
%=========================================================================
solve(Boat):-	

		%solve temp
		port(L),
		putTemp(Boat,L,  New),
		asserta(port(New)).

putTemp(L, [[_ | Rest1] | Rest2], New):- 	append([L], Rest1, L1),
											append([L1], Rest2, New).	



%=========================================================================
generate_boat(Types, Lines, Columnns, Boat):-

		get_nr(Lines, Columnns, N),
		random_between(1, N, Nr),
		
		generate_containers(Nr, Types, Nr, Boat).
		

generate_containers(0, _,_, Boat):- Boat = [].
generate_containers(Nr, Types, MaxTime, Boat):-

		%generate type
		random_between(1, Types, Type),
		append([Type], [], L1),
		
		%generate Weigth
		MaxWeigth is Type * 100,
		random_between(1, MaxWeigth, Weigth),
		append(L1, [Weigth], L2),
		
		%generate exp time
		random_between(1, MaxTime, Time),
		append(L2, [Time], L3),
		
		N2 is Nr - 1,
		generate_containers(N2, Types, MaxTime, Boat2),
		
		append([L3], Boat2, Boat).
		
		
get_nr(Lines, Columnns, Nr):-	Lines >= Columnns, Nr is Lines.
get_nr(Lines, Columnns, Nr):-	Lines < Columnns, Nr is Columnns.

%=========================================================================
create_port(Lines, Columnns):-	

		create_port_line(Lines, Columnns, L),
		asserta(port(L)).
		

create_port_line(0,_,L):- 	L = [].
create_port_line(Lines,Columnns,L):- 
		
		length(L1, Columnns),
		maplist(=([]), L1),
		N is Lines - 1,
		create_port_line(N, Columnns, L2),
		append([L1], L2, L).
		
display_port_by_length:-	

		port(L),
		display_matrix_by_length(L).

display_matrix_by_length([]):-	write('---------------------'), nl,nl.		
display_matrix_by_length([Line | Rest]):-	

		write('---------------------'), nl,
		display_line_by_length(Line), nl,
		display_matrix_by_length(Rest).
		
display_line_by_length([]):- write('|').
display_line_by_length([Elem | Rest]):-	
		
		length(Elem, N),
		write('| '), write(N), write(' '),
		display_line_by_length(Rest).

		
		
%=========================================================================
display_config(Lines, Columnns, Types):-
		
		write('Port Lines: '), write(Lines), nl,
		write('Port Columnns: '), write(Columnns), nl,	
		write('Container Types: '), write(Types), nl, nl.