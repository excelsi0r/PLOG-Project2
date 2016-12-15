:- include('config.pl').

:- use_module(library(lists)).

solve:-	

		create_port(Port),
		write(Port).

%======================================================
timing(Port, Total):-	
		
		check_if_empty(Port, Bool),		
		timing_eval(Port, Total, Bool).
		
timing_eval(Port, Total, 'true'):-	timing_not_empty(Port, Total).
timing_eval(_, Total, 'false'):-	Total is 0.
		
		
timing_not_empty(Port, Total):-	

		expedition(Port, NewPort, Time),
		update_times(NewPort, NewPort2),
		timing(NewPort2, Time2),
		Total is Times + Time2.
		
%======================================================
create_port(Port):-	
		
		port_lines(Lines),
		port_columns(Columnns),
		create_port_line(Lines, Columnns, Port).
		

create_port_line(0,_,L):- 	L = [].
create_port_line(Lines,Columnns,L):- 
		
		length(L1, Columnns),
		maplist(=([]), L1),
		N is Lines - 1,
		create_port_line(N, Columnns, L2),
		append([L1], L2, L).
		
%======================================================
check_if_empty(Port, Bool):-	

		flatten_port(Port, NewPort),
		length(NewPort, N),
		eval_check_if_empty(N, Bool).
		
eval_check_if_empty(N, Bool):-	N == 0, Bool = 'true'.
eval_check_if_empty(N, Bool):-	N \= 0, Bool = 'false'.

%=======================================================
flatten_port([], NewPort):-	NewPort = [].
flatten_port([Line | Rest], NewPort):-	

		flatten(Line, NewLine),
		flatten_port(Rest, NewRest),
		append(NewLine, NewRest, NewPort).
		
flatten([], NewLine):-	NewLine = [].
flatten([Elem | Rest], NewLine):-	

		flatten(Rest, NewLine2),
		append(Elem, NewLine2, NewLine).
		


		