:- include('config.pl').

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
		start_cycle(Types).
		

%=========================================================================

start_cycle(N):-	

		get_str,
		write('Next'),
		start_cycle(N).

get_str:-	
			repeat,
				get_char(C),
				C = '\n'.
	
	

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