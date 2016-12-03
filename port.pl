:- include('config.pl').

:- 	dynamic
	port/1.
	
port(_).

port_init:- 	
		write('Loading Port Configurations...'), nl, nl,
		
		port_lines(Lines),
		port_columns(Columnns),
		container_types(Types),
		
		display_config(Lines, Columnns, Types),
		
		create_port(Lines, Columnns),
		
		port(L),
		write(L).
		


create_port(Lines, Columnns):-	

		create_port_line(Lines, Columnns, L),
		assert(port(L)).
		

create_port_line(0,_,L):- 	L = [].
create_port_line(Lines,Columnns,L):- 
		
		lentgh(L1, Columnns),
		N is Lines - 1,
		create_port_line(N, Columnns, L2),
		append(L1, L2, L).


			
			
		
		
display_config(Lines, Columnns, Types):-
		
		write('Port Lines: '), write(Lines), nl,
		write('Port Columnns: '), write(Columnns), nl,	
		write('Container Types: '), write(Types), nl, nl.